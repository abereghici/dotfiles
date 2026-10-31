return {
  {
    "folke/snacks.nvim",
    -- Reopening an image left it stuck on the "… loading …" spinner or blank.
    -- Two upstream bugs in snacks.image placements, both unfixed on the pinned
    -- commit (882c996); see PRs folke/snacks.nvim#2918 and #2793.
    --   1. `Placement:progress()` starts an 80ms spinner timer whose stop
    --      condition can never become true once the placement is closed while
    --      its conversion is still running, so it leaks and keeps wiping the
    --      new placement's extmarks forever.
    --   2. `Placement:update()` calls `hide()` when no window shows the buffer,
    --      but nothing ever un-hides it, so coming back renders blank lines.
    -- Remove this once the fixes land upstream.
    init = function()
      LazyVim.on_load("snacks.nvim", function()
        local Placement = Snacks.image.placement
        local uv = vim.uv or vim.loop

        function Placement:progress()
          if self.opts.inline or self:ready() then
            return
          end
          vim.bo[self.buf].modifiable = true
          vim.api.nvim_buf_set_lines(self.buf, 0, -1, false, {})
          vim.bo[self.buf].modifiable = false
          local timer = assert(uv.new_timer())
          local eid ---@type number?
          timer:start(
            0,
            80,
            vim.schedule_wrap(function()
              -- `self.closed` added: a closed placement is never `ready()`
              if self.closed or self:ready() or self.img:failed() or not vim.api.nvim_buf_is_valid(self.buf) then
                timer:stop()
                if not timer:is_closing() then
                  timer:close()
                end
                -- the spinner extmark is untracked, so remove it here
                if eid and vim.api.nvim_buf_is_valid(self.buf) then
                  pcall(vim.api.nvim_buf_del_extmark, self.buf, Placement.ns, eid)
                end
                return
              end
              vim.api.nvim_buf_clear_namespace(self.buf, Placement.ns, 0, -1)
              eid = vim.api.nvim_buf_set_extmark(self.buf, Placement.ns, 0, 0, {
                virt_text = {
                  { Snacks.util.spinner(), "SnacksImageSpinner" },
                  { " " },
                  { self.img._convert:current().name .. " loading …", "SnacksImageLoading" },
                },
              })
            end)
          )
        end

        -- snacks.image.inline manages hide/show for inline images itself, so
        -- only un-latch buffer placements.
        local update = Placement.update
        function Placement:update()
          if self.hidden and not self.opts.inline and #self:wins() > 0 then
            self.hidden = false
          end
          return update(self)
        end
      end)
    end,
    opts = {
      scroll = { enabled = false },
      image = { enabled = true },
      picker = {
        actions = {
          -- Open the selected item's parent dir in oil.nvim (ported from fzf-lua <c-o>)
          oil_parent = function(picker, item)
            if not item then
              return
            end
            local file = Snacks.picker.util.path(item)
            if file then
              picker:close()
              require("oil").toggle_float(vim.fn.fnamemodify(file, ":h"))
            end
          end,
        },
        win = {
          input = {
            keys = {
              ["<c-o>"] = { "oil_parent", mode = { "n", "i" } },
            },
          },
        },
        sources = {
          -- The default git_status previewer routes modified/tracked files to
          -- `git diff`, which only prints "Binary files differ" for images.
          -- Route image files to the file/image previewer so they render.
          git_status = {
            preview = function(ctx)
              local preview = require("snacks.picker.preview")
              local path = Snacks.picker.util.path(ctx.item)
              if path and Snacks.image.supports_file(path) then
                return preview.file(ctx)
              end
              return preview.git_status(ctx)
            end,
          },
        },
      },
    },
    -- stylua: ignore
    keys = {
      -- Keep muscle memory: these search the cwd (root = false), matching the old fzf-lua maps
      { "<leader><space>", LazyVim.pick("files", { root = false }), desc = "Find Files (cwd)" },
      { "<leader>/", LazyVim.pick("live_grep", { root = false }), desc = "Grep (cwd)" },
    },
  },
}
