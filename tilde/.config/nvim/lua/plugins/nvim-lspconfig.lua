return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.eslint = opts.servers.eslint or {}
      -- no stylesheet filetypes here: eslint and stylelint both register a non-primary
      -- formatter at priority 200, so an overlap means two --fix passes per save.
      opts.servers.eslint.filetypes =
        vim.list_extend(vim.deepcopy(vim.lsp.config.eslint.filetypes or {}), { "json", "jsonc", "yaml" })

      -- mason installs @stylelint/language-server under the stylelint_lsp name, so this
      -- configures that server rather than adding a second one running the same binary.
      opts.servers.stylelint_lsp = {
        filetypes = { "css", "less", "scss", "sass" },
        settings = {
          stylelint = {
            -- default validate is only { "css", "postcss" }
            validate = { "css", "less", "scss", "sass" },
          },
        },
      }

      -- auto-fix on save via the server's documentFormatting (stylelint --fix)
      opts.setup = opts.setup or {}
      opts.setup.stylelint_lsp = function()
        LazyVim.format.register(LazyVim.lsp.formatter({
          name = "stylelint_lsp",
          primary = false,
          priority = 200,
          filter = "stylelint_lsp",
        }))
      end

      return opts
    end,
  },
}
