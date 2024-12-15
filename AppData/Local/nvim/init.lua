local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.opt.clipboard = "unnamedplus"
vim.opt.signcolumn = "yes"
vim.opt.number = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.incsearch = true
vim.opt.guicursor = ""
vim.opt.termguicolors = true
vim.opt.updatetime = 50
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
require("lazy").setup({
	{ "neovim/nvim-lspconfig" },
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/nvim-cmp" },
	{ "williamboman/mason.nvim" },
	{ "williamboman/mason-lspconfig.nvim" },
	{ "neovim/nvim-lspconfig" },
	{ "nvim-treesitter/nvim-treesitter" },
	{ "nvim-lua/plenary.nvim" },
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
	},
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
	},
	{ "nvim-telescope/telescope-ui-select.nvim" },
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
	},
	{ "nvim-tree/nvim-web-devicons" },
	{ "nvim-lualine/lualine.nvim" },
	{ "MunifTanjim/nui.nvim" },
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
	},
	{ "mfussenegger/nvim-jdtls" },
	{
		"goolord/alpha-nvim",
		config = function()
			require("alpha").setup(require("alpha.themes.dashboard").config)
		end,
	},
	{ "stevearc/conform.nvim" },
	{
		"Exafunction/codeium.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"hrsh7th/nvim-cmp",
		},
		config = function()
			require("codeium").setup({
				virtual_text = {
					enabled = true,
				},
			})
		end,
	},
})
require("telescope").load_extension("ui-select")
local lspconfig_defaults = require("lspconfig").util.default_config
lspconfig_defaults.capabilities =
	vim.tbl_deep_extend("force", lspconfig_defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())
vim.api.nvim_create_autocmd("LspAttach", {
	desc = "LSP actions",
	callback = function(event)
		local opts = { buffer = event.buf }
		vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
		vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
		vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
		vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
		vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
		vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
		vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
		vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
		vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua require('conform').format()<cr>", opts)
		vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
	end,
})
local cmp = require("cmp")
cmp.setup({
	sources = {
		{ name = "nvim_lsp" },
		{ name = "codeium" },
	},
	snippet = {
		expand = function(args)
			vim.snippet.expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<CR>"] = cmp.mapping.confirm({ select = true }),
	}),
})
require("mason").setup({})
require("mason-lspconfig").setup({
	ensure_installed = { "clangd", "lua_ls", "html", "ts_ls", "emmet_ls", "cssls" },
	handlers = {
		function(server_name)
			require("lspconfig")[server_name].setup({})
		end,
	},
})
require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"c",
		"lua",
		"vim",
		"vimdoc",
		"query",
		"markdown",
		"markdown_inline",
		"html",
		"css",
		"javascript",
		"typescript",
		"java",
	},
	sync_install = false,
	auto_install = true,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
})
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
local harpoon = require("harpoon")
harpoon:setup({})
vim.keymap.set("n", "<leader>a", function()
	harpoon:list():add()
end)
vim.keymap.set("n", "<C-e>", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end)
vim.keymap.set("n", "<C-h>", function()
	harpoon:list():select(1)
end)
vim.keymap.set("n", "<C-t>", function()
	harpoon:list():select(2)
end)
vim.keymap.set("n", "<C-n>", function()
	harpoon:list():select(3)
end)
vim.keymap.set("n", "<C-s>", function()
	harpoon:list():select(4)
end)
vim.keymap.set("n", "<C-S-P>", function()
	harpoon:list():prev()
end)
vim.keymap.set("n", "<C-S-N>", function()
	harpoon:list():next()
end)
local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
	local file_paths = {}
	for _, item in ipairs(harpoon_files.items) do
		table.insert(file_paths, item.value)
	end

	require("telescope.pickers")
		.new({}, {
			prompt_title = "Harpoon",
			finder = require("telescope.finders").new_table({
				results = file_paths,
			}),
			previewer = conf.file_previewer({}),
			sorter = conf.generic_sorter({}),
		})
		:find()
end
vim.keymap.set("n", "<C-e>", function()
	toggle_telescope(harpoon:list())
end, { desc = "Open harpoon window" })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.opt.undofile = true
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.opt.undofile = true
vim.cmd([[colorscheme catppuccin]])
require("lualine").setup({
	options = { globalstatus = true },
})
vim.keymap.set("n", "<C-n>", "<Cmd>Neotree toggle<CR>")
local jdtls = require("jdtls")
if vim.bo.filetype == "java" then
	local config = {
		cmd = { vim.fn.expand("C:/Users/Panjwani/AppData/Local/nvim-data/mason/bin/jdtls.cmd") },
		root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw" }, { upward = true })[1]),
	}
	jdtls.start_or_attach(config)
end
local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")
dashboard.section.header.val = {
	"                                                     ",
	"  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
	"  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
	"  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
	"  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
	"  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
	"  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
	"                                                     ",
}
dashboard.section.buttons.val = {
	dashboard.button("e", "  > New file", ":ene <BAR> startinsert <CR>"),
	dashboard.button("f", "  > Find file", ":cd $HOME | Telescope find_files<CR>"),
	dashboard.button("s", "  > Settings", ":e $MYVIMRC | :cd %:p:h | split . | wincmd k | pwd<CR>"),
	dashboard.button("q", "  > Quit NVIM", ":qa<CR>"),
}
local fortune = require("alpha.fortune")
dashboard.section.footer.val = fortune()
alpha.setup(dashboard.opts)
vim.cmd([[
    autocmd FileType alpha setlocal nofoldenable
]])
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		javascript = { "prettier", stop_after_first = true },
		c = { "clang-format" },
		html = { "prettier" },
		css = { "prettier" },
	},
})
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})
