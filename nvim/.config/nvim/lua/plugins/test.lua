return {
  { "haydenmeade/neotest-jest" }, -- Or "nvim-neotest/neotest-jest" depending on the source
  {
    "nvim-neotest/neotest",
    dependencies = { "haydenmeade/neotest-jest" }, -- Ensure neotest-jest is a dependency
    opts = function(_, opts)
      table.insert(
        opts.adapters,
        require("neotest-jest")({
          jestCommand = "npm test --", -- Or your preferred Jest command
          -- Optional: Configure other neotest-jest options like jestConfigFile, cwd, etc.
          -- jestConfigFile = "jest.config.js",
          -- cwd = function() return vim.fn.getcwd() end,
        })
      )
    end,
  },
}
