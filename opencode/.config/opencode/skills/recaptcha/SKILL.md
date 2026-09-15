---
name: recaptcha
description: Google reCAPTCHA Enterprise integration for TanStack Start
---

## Overview

This skill documents how to integrate Google reCAPTCHA Enterprise v1 with a TanStack Start application using Resend for email.

## Architecture

```
Client (Browser)                    Server (TanStack Start)
      │                                    │
      │  1. User submits form             │
      │──────────────────────────────────>│
      │                                    │
      │  2. Load reCAPTCHA script        │
      │    (lazy, on submit click)       │
      │                                    │
      │  3. grecaptcha.enterprise.execute │
      │    returns token                  │
      │<──────────────────────────────────│
      │                                    │
      │  4. Send token + form data        │
      │    to createServerFn              │
      │──────────────────────────────────>│
      │                                    │
      │                        5. Verify token via
      │                           Google Cloud API
      │                        POST /v1/projects/{project}/assessments
      │                                    │
      │                        6. Send email via Resend
      │                                    │
      │  7. Return result                 │
      │<──────────────────────────────────│
```

## Files

### Client (src/components/sections/contact-section.tsx)

```tsx
"use client";

import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Label } from "@/components/ui/label";
import { submitContactFn } from "@/routes/api/contact";

const RECAPTCHA_SITE_KEY = import.meta.env.VITE_RECAPTCHA_SITE_KEY;

declare global {
  interface Window {
    grecaptcha: {
      enterprise: {
        ready: (callback: () => void) => void;
        execute: (siteKey: string, options: { action: string }) => Promise<string>;
      };
    };
  }
}

export function ContactSection() {
  const [formState, setFormState] = useState({
    name: "",
    email: "",
    company: "",
    message: "",
  });
  const [isLoading, setIsLoading] = useState(false);
  const [statusMessage, setStatusMessage] = useState("");
  const [showStatus, setShowStatus] = useState(false);

  const loadRecaptcha = () => {
    if (typeof window === "undefined" || window.grecaptcha?.enterprise) return;
    const script = document.createElement("script");
    script.src = `https://www.google.com/recaptcha/enterprise.js?render=${RECAPTCHA_SITE_KEY}`;
    script.async = true;
    script.defer = true;
    document.head.appendChild(script);
  };

  const handleSubmit = async (token: string) => {
    setIsLoading(true);
    setStatusMessage("");

    try {
      const response = await submitContactFn({
        data: {
          to: formState.email,
          name: formState.name,
          phone: formState.company || "Not provided",
          message: formState.message,
          recaptchaToken: token,
        },
      });

      const result = await response.json();
      setStatusMessage(result.message);
      setShowStatus(true);

      if (result.success) {
        setFormState({ name: "", email: "", company: "", message: "" });
      }
    } catch {
      setStatusMessage("Error sending message. Please try again.");
      setShowStatus(true);
    } finally {
      setIsLoading(false);
    }
  };

  const onSubmit = (e: React.FormEvent) => {
    e.preventDefault();

    if (!RECAPTCHA_SITE_KEY || typeof window === "undefined") {
      handleSubmit("");
      return;
    }

    if (!window.grecaptcha?.enterprise) {
      loadRecaptcha();
      const checkInterval = setInterval(() => {
        if (window.grecaptcha?.enterprise) {
          clearInterval(checkInterval);
          window.grecaptcha.enterprise.ready(() => {
            window.grecaptcha.enterprise.execute(RECAPTCHA_SITE_KEY, { action: "submit" }).then((token: string) => {
              handleSubmit(token);
            });
          });
        }
      }, 100);
      return;
    }

    window.grecaptcha.enterprise.ready(() => {
      window.grecaptcha.enterprise.execute(RECAPTCHA_SITE_KEY, { action: "submit" }).then((token: string) => {
        handleSubmit(token);
      });
    });
  };

  const isFormValid = formState.name && formState.email && formState.message;

  return (
    <form onSubmit={onSubmit}>
      {/* form fields */}
      <Button type="submit" className="w-full" disabled={!isFormValid || isLoading}>
        {isLoading ? "Sending..." : "Send Message"}
      </Button>
      {showStatus && <div>{statusMessage}</div>}
    </form>
  );
}
```

### Server (src/routes/api/contact.ts)

```ts
import { createServerFn } from "@tanstack/react-start";
import { sendContactEmail } from "@/lib/email.server";

const submitContactFn = createServerFn({ method: "POST" })
  .validator(async (body: {
    to: string;
    name: string;
    phone: string;
    message: string;
    recaptchaToken: string;
  }) => {
    return body;
  })
  .handler(async ({ data }) => {
    try {
      const result = await sendContactEmail({
        to: data.to,
        name: data.name,
        phone: data.phone,
        message: data.message,
        token: data.recaptchaToken,
      });

      return Response.json(result);
    } catch (error) {
      console.error("Contact API error:", error);
      return Response.json(
        { success: false, message: "Internal server error" },
        { status: 500 }
      );
    }
  });

export { submitContactFn };
```

### Email (src/lib/email.server.ts)

```ts
import { Resend } from "resend";

const RECAPTCHA_SECRET_KEY = process.env.RECAPTCHA_SECRET_KEY;
const RESEND_API_KEY = process.env.RESEND_API_KEY;
const RECAPTCHA_PROJECT_ID = process.env.RECAPTCHA_PROJECT_ID;

const resend = RESEND_API_KEY ? new Resend(RESEND_API_KEY) : null;

interface RecaptchaEnterpriseResponse {
  tokenProperties: {
    valid: boolean;
    invalidReason?: string;
    hostname?: string;
    action?: string;
    createTime?: string;
  };
  riskAnalysis: {
    score: number;
    reasons?: string[];
  };
}

async function verifyRecaptchaEnterprise(token: string): Promise<{ valid: boolean; score: number }> {
  if (!RECAPTCHA_SECRET_KEY || !RECAPTCHA_PROJECT_ID) {
    console.warn("reCAPTCHA Enterprise credentials not configured, skipping verification");
    return { valid: true, score: 1.0 };
  }

  try {
    const url = `https://recaptchaenterprise.googleapis.com/v1/projects/${RECAPTCHA_PROJECT_ID}/assessments?key=${RECAPTCHA_SECRET_KEY}`;

    const res = await fetch(url, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        event: {
          token,
          expectedAction: "submit",
          siteKey: import.meta.env.VITE_RECAPTCHA_SITE_KEY,
        },
      }),
    });

    const data = (await res.json()) as RecaptchaEnterpriseResponse;

    if (!data.tokenProperties?.valid) {
      console.warn("reCAPTCHA token invalid:", data.tokenProperties?.invalidReason);
      return { valid: false, score: 0 };
    }

    return {
      valid: data.tokenProperties.valid,
      score: data.riskAnalysis?.score ?? 0,
    };
  } catch (error) {
    console.error("reCAPTCHA Enterprise verification failed:", error);
    return { valid: false, score: 0 };
  }
}

export async function sendContactEmail({
  to,
  name,
  phone,
  message,
  token,
}: {
  to: string;
  name: string;
  phone: string;
  message: string;
  token: string;
}): Promise<{ success: boolean; message: string }> {
  // Skip verification if no token (localhost dev without reCAPTCHA)
  if (!token) {
    console.warn("No reCAPTCHA token, skipping verification");
  } else {
    const { valid, score } = await verifyRecaptchaEnterprise(token);
    if (!valid || score < 0.5) {
      return {
        success: false,
        message: "We couldn't send your message. Please try again later.",
      };
    }
  }

  if (!resend) {
    console.error("RESEND_API_KEY not configured");
    return { success: false, message: "Email service not configured" };
  }

  try {
    await resend.emails.send({
      from: "Sounds Good <hello@soundsgood.lat>",
      to: [to],
      subject: "Thanks for reaching out",
      html: `<div>Hey ${name}!<br><br>Thanks for reaching out! We'll call you at ${phone}.<br><br>Best,<br>The Sounds Good Team</div>`,
    });

    await resend.emails.send({
      from: "Sounds Good <hello@soundsgood.lat>",
      to: ["hello@soundsgood.lat"],
      subject: `${name} is waiting for you.`,
      html: `<div>Hey!<br><br>${name} reached out.<br><br>Phone: ${phone}<br>Email: ${to}<br><br>Message:<br>${message}</div>`,
    });

    return { success: true, message: "We'll be in touch soon!" };
  } catch (error) {
    console.error("Failed to send email:", error);
    return { success: false, message: "Error sending message. Please try again." };
  }
}
```

## Environment Variables

### Client (.env)

```env
VITE_RECAPTCHA_SITE_KEY=your_recaptcha_site_key
```

### Server (.env)

```env
RECAPTCHA_SECRET_KEY=your_google_cloud_api_key
RECAPTCHA_PROJECT_ID=your_project_id
RESEND_API_KEY=your_resend_api_key
```

## Google Cloud Setup

1. **Create a reCAPTCHA Enterprise site**:
   - Go to https://www.google.com/recaptcha/admin/create
   - Select "Enterprise" type
   - Add your domains (localhost for dev, production domain for prod)

2. **Get the site key** (for client):
   - From the reCAPTCHA admin console
   - Use as `VITE_RECAPTCHA_SITE_KEY`

3. **Create an API Key** (for server):
   - Go to Google Cloud Console > APIs & Services > Credentials
   - Create an API Key (or use existing)
   - Enable "reCAPTCHA Enterprise API"
   - Add website restrictions if needed (remove for local testing)
   - Use as `RECAPTCHA_SECRET_KEY`

4. **Get Project ID**:
   - From Google Cloud Console > Home > Project Info
   - Or from the assessment URL: `projects/sounds-good-417320/assessments`
   - Use as `RECAPTCHA_PROJECT_ID`

## Notes

- reCAPTCHA Enterprise returns `score: 1.0` for localhost by default (no real fraud analysis)
- In production, it performs actual fraud analysis
- Score threshold of 0.5 is used - adjust as needed
- The script loads lazily only when user clicks submit (privacy-friendly)
- API key website restrictions must include the domain or be removed for testing
