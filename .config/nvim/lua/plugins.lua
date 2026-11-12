-- Plugin manager: lazy.nvim
-- 各プラグインの設定は plugin/*.lua にあり、lazy.nvim がプラグイン読み込み後に source する

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
    }, true, {})
    return
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { "nvim-lua/plenary.nvim" }, -- Common utilities

  -- Colorschemes
  { "EdenEast/nightfox.nvim", priority = 1000 }, -- Color scheme

  {
    "nvim-lualine/lualine.nvim", -- Statusline
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  { "windwp/nvim-autopairs" }, -- Autopairs, integrates with both cmp and treesitter
  { "akinsho/bufferline.nvim" },

  -- cmp plugins
  { "hrsh7th/nvim-cmp" }, -- The completion plugin
  { "hrsh7th/cmp-buffer" }, -- buffer completions
  { "hrsh7th/cmp-path" }, -- path completions
  { "hrsh7th/cmp-cmdline" }, -- cmdline completions
  { "saadparwaiz1/cmp_luasnip" }, -- snippet completions
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-nvim-lua" },
  { "onsails/lspkind-nvim" },

  -- snippets
  { "L3MON4D3/LuaSnip" }, --snippet engine

  -- LSP
  { "neovim/nvim-lspconfig" }, -- enable LSP
  { "nvimdev/lspsaga.nvim" }, -- LSP UIs

  -- Telescope
  { "nvim-telescope/telescope.nvim" },
  { "nvim-telescope/telescope-file-browser.nvim" },

  -- Treesitter
  -- master ブランチはアーカイブ済みで Neovim 0.12 と非互換のため main ブランチを使う（main は遅延読み込み非対応）
  { "nvim-treesitter/nvim-treesitter", branch = "main", lazy = false, build = ":TSUpdate" },

  -- VSCode like にする
  { "lukas-reineke/indent-blankline.nvim" },

  -- control im status automatically
  { "brglng/vim-im-select" },

  { "windwp/nvim-ts-autotag" },

  { "folke/zen-mode.nvim", opts = {} },
}, {
  ui = { border = "rounded" },
  -- 初回インストール画面でも nightfox を使う
  install = { colorscheme = { "nightfox", "default" } },
  -- 更新の自動チェックはしない（:Lazy から手動で更新）
  checker = { enabled = false },
  change_detection = { notify = false },
  -- luarocks が必要なプラグインは無いので無効化（checkhealth のエラー回避）
  rocks = { enabled = false },
})
