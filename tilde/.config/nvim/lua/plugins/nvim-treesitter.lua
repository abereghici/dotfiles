return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "css", "go", "java", "graphql", "gitignore", "kdl" })
      -- Parsers required by snacks.image to render images/math embedded in these doc types
      vim.list_extend(opts.ensure_installed, { "latex", "scss", "svelte", "typst", "vue" })
    end,
    config = function()
      -- MDX
      vim.filetype.add({
        extension = {
          mdx = "mdx",
        },
      })

      vim.treesitter.language.register("markdown", "mdx")
    end,
  },
}
