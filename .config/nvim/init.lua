require("base")
require("autocmds")
require("options")
require("keymaps")
-- lazy.nvim はプラグイン読み込み後でないと colorscheme が見つからないため plugins を先に読む
require("plugins")
require("colorscheme")
