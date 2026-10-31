-- Keymaps for Neovim running inside VS Code (vscode-neovim), loaded from keymaps.lua.
-- LazyVim's vscode extra (auto-enabled when `vim.g.vscode` is set) already maps
-- <leader><space>, <leader>/, <leader>ss, <leader>ft/fT/<c-/>, H and L, and vscode-neovim
-- itself maps gd, K, <C-w>* (so LazyVim's <C-h/j/k/l>, <leader>-, <leader>| and <leader>wd
-- work as is). This adds the rest of the LazyVim muscle memory that would otherwise call
-- plugins or LSP clients that don't run here. Bindings for non-editor views (explorer,
-- terminal, quick open) live in vscode/keybindings.json.
local vscode = require("vscode")

local function map(mode, lhs, action, desc, opts)
  local rhs = type(action) == "function" and action or function()
    vscode.action(action)
  end
  vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", { desc = desc }, opts or {}))
end

-- Find / search (snacks picker)
map("n", "<leader>ff", "workbench.action.quickOpen", "Find Files")
map("n", "<leader>fF", "workbench.action.quickOpen", "Find Files")
map("n", "<leader>fr", "workbench.action.openRecent", "Recent")
map("n", "<leader>,", "workbench.action.showAllEditorsByMostRecentlyUsed", "Buffers")
map("n", "<leader>fb", "workbench.action.showAllEditorsByMostRecentlyUsed", "Buffers")
map("n", "<leader>sg", "workbench.action.findInFiles", "Grep")
map("n", "<leader>sw", function()
  vscode.action("workbench.action.findInFiles", { args = { { query = vim.fn.expand("<cword>") } } })
end, "Grep Word")
map("n", "<leader>sr", "workbench.action.replaceInFiles", "Search and Replace")
map("n", "<leader>sS", "workbench.action.showAllSymbols", "LSP Workspace Symbols")
map("n", "<leader>sk", "workbench.action.openGlobalKeybindings", "Keymaps")
map("n", "<leader>sC", "workbench.action.showCommands", "Commands")
map("n", "<leader>:", "workbench.action.showCommands", "Commands")

-- Explorer (oil.nvim): reveal the current file, or just open the explorer.
-- <leader>e or q in the explorer closes it again (keybindings.json).
map("n", "<leader>e", "workbench.files.action.showActiveFileInExplorer", "Explorer (File Dir)")
map("n", "<leader>fe", "workbench.files.action.showActiveFileInExplorer", "Explorer (File Dir)")
map("n", "<leader>E", "workbench.view.explorer", "Explorer (cwd)")
map("n", "<leader>fE", "workbench.view.explorer", "Explorer (cwd)")

-- Buffers are editors (tabs)
map("n", "<leader>bd", "workbench.action.closeActiveEditor", "Delete Buffer")
map("n", "<leader>bo", "workbench.action.closeOtherEditors", "Delete Other Buffers")
map("n", "<leader>bl", "workbench.action.closeEditorsToTheLeft", "Delete Buffers to the Left")
map("n", "<leader>br", "workbench.action.closeEditorsToTheRight", "Delete Buffers to the Right")
map("n", "<leader>bb", "workbench.action.openPreviousRecentlyUsedEditorInGroup", "Switch to Other Buffer")
map("n", "<leader>`", "workbench.action.openPreviousRecentlyUsedEditorInGroup", "Switch to Other Buffer")
map("n", "[b", "workbench.action.previousEditor", "Prev Buffer")
map("n", "]b", "workbench.action.nextEditor", "Next Buffer")

-- Harpoon: pin the editor (pinned tabs stay first), then jump to tab 1-9
map("n", "<leader>h", "workbench.action.pinEditor", "Harpoon File (pin editor)")
map("n", "<leader>fh", "workbench.action.showEditorsInActiveGroup", "Harpoon Quick Menu (editors)")
for i = 1, 9 do
  map("n", "<leader>" .. i, "workbench.action.openEditorAtIndex" .. i, "Harpoon to File " .. i)
end

-- Windows (splits are handled through vscode-neovim's <C-w> maps)
map("n", "<leader>wm", "workbench.action.toggleMaximizeEditorGroup", "Zoom Mode")
map("n", "<leader>uZ", "workbench.action.toggleMaximizeEditorGroup", "Zoom Mode")

-- LSP (vscode-neovim maps gd and K)
map("n", "gr", "editor.action.goToReferences", "References", { nowait = true })
map("n", "gI", "editor.action.goToImplementation", "Goto Implementation")
map("n", "gy", "editor.action.goToTypeDefinition", "Goto T[y]pe Definition")
map("n", "gD", "editor.action.revealDeclaration", "Goto Declaration")
map("n", "gK", "editor.action.triggerParameterHints", "Signature Help")
map({ "n", "x" }, "<leader>ca", "editor.action.quickFix", "Code Action")
map("n", "<leader>cA", "editor.action.sourceAction", "Source Action")
map("n", "<leader>co", "editor.action.organizeImports", "Organize Imports")
map("n", "<leader>cr", "editor.action.rename", "Rename")
map("n", "<leader>cs", "outline.focus", "Symbols (Outline)")
map("n", "<leader>cf", "editor.action.formatDocument", "Format")
map("x", "<leader>cf", "editor.action.formatSelection", "Format")
-- Custom gldv/gldh: definition in a vertical/horizontal split
map("n", "gldv", "editor.action.revealDefinitionAside", "Goto Definition (vertical)")
map("n", "gldh", function()
  vscode.call("workbench.action.splitEditorDown")
  vscode.action("editor.action.revealDefinition")
end, "Goto Definition (horizontal)")

-- Diagnostics, quickfix (search results) and git hunks
map("n", "]d", "editor.action.marker.next", "Next Diagnostic")
map("n", "[d", "editor.action.marker.prev", "Prev Diagnostic")
map("n", "<leader>cd", "editor.action.showHover", "Line Diagnostics")
map("n", "<leader>xx", "workbench.actions.view.toggleProblems", "Diagnostics (Problems)")
map("n", "<leader>xX", "workbench.actions.view.toggleProblems", "Diagnostics (Problems)")
map("n", "]q", "search.action.focusNextSearchResult", "Next Quickfix (search result)")
map("n", "[q", "search.action.focusPreviousSearchResult", "Prev Quickfix (search result)")
map("n", "]h", "workbench.action.editor.nextChange", "Next Hunk")
map("n", "[h", "workbench.action.editor.previousChange", "Prev Hunk")

-- Git: lazygit full-size in an editor tab (the shell isn't involved, so `q` closes the tab)
local function lazygit()
  vscode.eval([[
    vscode.window.createTerminal({
      name: "lazygit",
      shellPath: "lazygit",
      location: { viewColumn: vscode.ViewColumn.Active },
    }).show();
  ]])
end
map("n", "<leader>gg", lazygit, "Lazygit (Root Dir)")
map("n", "<leader>gG", lazygit, "Lazygit (cwd)")
map("n", "<leader>gs", "workbench.view.scm", "Git Status (Source Control)")
map("n", "<leader>gn", "workbench.view.scm", "Neogit (Source Control)")
map("n", "<leader>ghs", "git.stageSelectedRanges", "Stage Hunk")
map("n", "<leader>ghr", "git.revertSelectedRanges", "Reset Hunk")
map("n", "<leader>ghp", "editor.action.dirtydiff.next", "Preview Hunk")

-- Copy the file path (expand("%:p") isn't the file path here)
map("n", "<leader>yp", "copyFilePath", "Copy file path")

-- Debug (dap) and tests (neotest)
map("n", "<leader>db", "editor.debug.action.toggleBreakpoint", "Toggle Breakpoint")
map("n", "<leader>dB", "editor.debug.action.conditionalBreakpoint", "Breakpoint Condition")
map("n", "<leader>dc", "workbench.action.debug.continue", "Run/Continue")
map("n", "<leader>di", "workbench.action.debug.stepInto", "Step Into")
map("n", "<leader>dO", "workbench.action.debug.stepOver", "Step Over")
map("n", "<leader>do", "workbench.action.debug.stepOut", "Step Out")
map("n", "<leader>dt", "workbench.action.debug.stop", "Terminate")
map("n", "<leader>tt", "testing.runCurrentFile", "Run File")
map("n", "<leader>tT", "testing.runAll", "Run All Test Files")
map("n", "<leader>tr", "testing.runAtCursor", "Run Nearest")
map("n", "<leader>tl", "testing.reRunLastRun", "Run Last")
map("n", "<leader>td", "testing.debugAtCursor", "Debug Nearest")
map("n", "<leader>to", "testing.showMostRecentOutput", "Show Output")
map("n", "<leader>ts", "workbench.view.extension.test", "Toggle Summary")

-- AI (copilot-chat)
map({ "n", "x" }, "<leader>aa", "workbench.action.chat.toggle", "Toggle (Copilot Chat)")
map({ "n", "x" }, "<leader>aq", "inlineChat.start", "Quick Chat (inline)")

-- UI toggles
map("n", "<leader>uw", "editor.action.toggleWordWrap", "Toggle Wrap")
map("n", "<leader>uz", "workbench.action.toggleZenMode", "Toggle Zen Mode")
map("n", "<leader>ub", "workbench.action.toggleLightDarkThemes", "Toggle Dark Background")
map("n", "<leader>uC", "workbench.action.selectTheme", "Colorschemes")

-- Quit: close this VS Code window (one window per project, like one nvim per project)
map("n", "<leader>qq", "workbench.action.closeWindow", "Quit All")
