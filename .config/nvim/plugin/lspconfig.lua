-- nvim-lspconfig（各サーバーの既定設定）が無ければ何もしない
if not pcall(require, "lspconfig") then
	return
end

local protocol = require("vim.lsp.protocol")

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
	local function buf_set_keymap(...)
		vim.api.nvim_buf_set_keymap(bufnr, ...)
	end

	local function buf_set_option(...)
		vim.api.nvim_buf_set_option(bufnr, ...)
	end

	--Enable completion triggered by <c-x><c-o>
	buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

	-- Mappings.
	local opts = { noremap = true, silent = true }

	-- See `:help vim.lsp.*` for documentation on any of the below functions
	buf_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	-- Lspsaga の方を使うのでここはコメントアウト
	--buf_set_keymap("n", "ga", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)

  -- formatting
  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("Format", { clear = true }),
      buffer = bufnr,
      callback = function() vim.lsp.buf.format() end
    })
  end

	-- To send formatted stream to null-ls
	--client.resolved_capabilities.document_formatting = false
end

protocol.CompletionItemKind = {
	"", -- Text
	"", -- Method
	"", -- Function
	"", -- Constructor
	"", -- Field
	"", -- Variable
	"", -- Class
	"ﰮ", -- Interface
	"", -- Module
	"", -- Property
	"", -- Unit
	"", -- Value
	"", -- Enum
	"", -- Keyword
	"﬌", -- Snippet
	"", -- Color
	"", -- File
	"", -- Reference
	"", -- Folder
	"", -- EnumMember
	"", -- Constant
	"", -- Struct
	"", -- Event
	"ﬦ", -- Operator
	"", -- TypeParameter
}

-- Set up completion using nvim_cmp with LSP source
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- require("lspconfig").xxx.setup() は非推奨になったため、Neovim 0.11+ の vim.lsp.config / vim.lsp.enable を使う
-- （各サーバーの既定設定は nvim-lspconfig の lsp/*.lua が提供する）

-- 全サーバー共通の設定
vim.lsp.config("*", {
	on_attach = on_attach,
	capabilities = capabilities,
})

vim.lsp.config("ts_ls", {
	filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
	cmd = { "typescript-language-server", "--stdio" },
})

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},

			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
		},
	},
})

vim.lsp.enable({ "ts_ls", "sourcekit", "lua_ls" })

-- flow はインストールされている場合のみ有効化（未インストールだと起動失敗の警告が出るため）
if vim.fn.executable("flow") == 1 then
	vim.lsp.enable("flow")
end

-- Diagnostic symbols in the sign column (gutter)
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
local sign_text = {}
for type, icon in pairs(signs) do
	sign_text[vim.diagnostic.severity[type:upper()]] = icon
end

vim.diagnostic.config({
	underline = true,
	severity_sort = true,
	signs = { text = sign_text },
	virtual_text = {
		spacing = 4,
		prefix = "●",
	},
	update_in_insert = true,
	float = {
		source = true, -- Or "if_many"
	},
})
