-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end
vim.api.nvim_exec([[
augroup Packer
autocmd!
autocmd BufWritePost init.lua PackerCompile
augroup end
]], false)

-- Plugins
local use = require('packer').use
require('packer').startup(function()
	-- base
	use 'wbthomason/packer.nvim' -- Package manager
	use 'neovim/nvim-lspconfig' -- Collection of configurations for built-in LSP client
	use 'nvim-treesitter/nvim-treesitter' -- incremental parser
	use 'nvim-treesitter/nvim-treesitter-textobjects' -- add textobjects to the parser

	-- languages
	use 'fatih/vim-go' -- Golang
	use 'pearofducks/ansible-vim' -- Ansible

	-- features
	use 'axelf4/vim-strip-trailing-whitespace' -- remove trailing whitespaces on changed lines only
	use 'sheerun/vim-polyglot' -- identation
	use 'b3nj5m1n/kommentary' -- comments
	use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
	use 'hrsh7th/cmp-nvim-lsp' -- cmp source: nvim lsp
	use 'hrsh7th/cmp-path' -- cmp source: system paths
	use 'ray-x/cmp-treesitter' -- cmp source: treesitter
	use 'saadparwaiz1/cmp_luasnip' -- cmp source: luasnip
	use 'onsails/lspkind-nvim' -- type icons for cmp suggestions
	use 'L3MON4D3/LuaSnip' -- Snippets plugin

	-- UI
	use 'rakshazi/darcula' -- colorscheme
	use { 'akinsho/bufferline.nvim', requires = 'kyazdani42/nvim-web-devicons' } -- bufferline
	use { 'hoob3rt/lualine.nvim', requires = 'kyazdani42/nvim-web-devicons' } -- statusline
	use { 'kyazdani42/nvim-tree.lua', requires = 'kyazdani42/nvim-web-devicons' } -- nerdtree-like
	use 'folke/lsp-colors.nvim' -- colorscheme fix for not (yet) supported LSP colors
	use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } } -- git diff for lines
	use 'lukas-reineke/indent-blankline.nvim' -- indentation guides even on blank lines
	use 'kevinhwang91/nvim-bqf' -- quickfix windows enhancer
	use { 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/plenary.nvim' } } -- UI to select things
	use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' } -- native fzf implementation
end)

-- Incremental live completion (note: this is now a default on master)
vim.o.inccommand = 'nosplit'

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Do not save when switching buffers (note: this is now a default on master)
vim.o.hidden = true

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

-- Folding
vim.o.foldmethod = 'syntax'
vim.o.foldnestmax = 1

-- Set colorscheme (order is important here)
vim.o.termguicolors = true
vim.cmd [[colorscheme darcula]]

-- Set bufferline
require("bufferline").setup{
	options = {
		diagnostics = "nvim_lsp",
		show_buffer_icons = true,
		show_buffer_close_icons = false,
		show_close_icon = false,
		always_show_bufferline = true
	}
}

-- Set buffer hotkeys
vim.api.nvim_set_keymap('n', '<C-w>', ':w|bd<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-n>', ':BufferLineCycleNext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-p>', ':BufferLineCyclePrev<CR>', { noremap = true, silent = true })

-- Set statusbar
require('lualine').setup{
	options = { theme = 'codedark' },
	extensions = { 'nvim-tree' },
}

-- Set quickfix enhancer
require('bqf').setup{
	auto_enable = true,
}

-- Remap space as leader key
vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Remap for dealing with word wrap
vim.api.nvim_set_keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
vim.api.nvim_set_keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })

-- Ctrl+S
vim.api.nvim_set_keymap('n', '<C-s>', ':w<CR>', { noremap = true, silent = true })

-- Highlight on yank
vim.api.nvim_exec([[
augroup YankHighlight
autocmd!
autocmd TextYankPost * silent! lua vim.highlight.on_yank()
augroup end
]], false)

-- Map blankline
vim.g.indent_blankline_char = '┊'
vim.g.indent_blankline_filetype_exclude = { 'help', 'packer' }
vim.g.indent_blankline_buftype_exclude = { 'terminal', 'nofile' }
vim.g.indent_blankline_char_highlight = 'LineNr'
vim.g.indent_blankline_show_trailing_blankline_indent = false

-- nerdtree-like
vim.api.nvim_set_keymap('', '<C-e>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
vim.g.nvim_tree_git_hl = 1
vim.g.nvim_tree_special_files = {}

require('nvim-tree').setup {
	auto_resize = true,
	hijack_cursor = true,
	open_on_setup = true,
	actions = {
		open_file = {
			quit_on_open = 1,
		},
	},
	diagnostics = {
		enable = true,
		icons = {
			hint = "",
			info = "",
			warning = "",
			error = "",
		}
	},
	git = {
		enable = true,
		ignore = false,
		timeout = 500
	},
	view = {
		mappings = {
			list = {
				{ key = '<C-e>', action = "close" },
			},
		},
	},
}

-- nerdcommenter
-- alternative keymap: gcc
vim.api.nvim_set_keymap('i', '<C-_>', '<Plug>kommentary_line_default', {})
vim.api.nvim_set_keymap('n', '<C-_>', '<Plug>kommentary_line_default', {})
vim.api.nvim_set_keymap('v', '<C-_>', '<Plug>kommentary_visual_default', {})

-- ansible-vim
vim.g.ansible_unindent_after_newline = 1
vim.g.ansible_extra_keywords_highlight = 1

-- vim-go
vim.g.go_auto_sameids = 1
vim.g.go_auto_type_info = 1
vim.g.go_doc_popup_window = 1
vim.g.go_fmt_command = 'goimports'
vim.g.go_fmt_experimental = 1
vim.g.go_gopls_enabled =1
vim.g.go_highlight_extra_types = 1
vim.g.go_highlight_fields = 1
vim.g.go_highlight_function_calls = 1
vim.g.go_highlight_functions = 1
vim.g.go_highlight_operators = 1
vim.g.go_highlight_types = 1
vim.g.go_metalinter_autosave = 1
vim.g.go_metalinter_autosave = 1
vim.g.go_term_enabled = 1

-- Gitsigns
require('gitsigns').setup {
	signs = {
		add = { hl = 'GitGutterAdd', text = '+' },
		change = { hl = 'GitGutterChange', text = '~' },
		delete = { hl = 'GitGutterDelete', text = '_' },
		topdelete = { hl = 'GitGutterDelete', text = '‾' },
		changedelete = { hl = 'GitGutterChange', text = '~' },
	},
}

-- Telescope
require('telescope').setup {
	defaults = {
		mappings = {
			i = {
				['<C-u>'] = false,
				['<C-d>'] = false,
			},
		},
	},
	extensions = {
		fzf = {
			fuzzy = true,                    -- false will only do exact matching
			override_generic_sorter = true,  -- override the generic sorter
			override_file_sorter = true,     -- override the file sorter
			case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
			-- the default case_mode is "smart_case"
		}
	},
}
-- Add leader shortcuts
vim.api.nvim_set_keymap('n', '`', [[<cmd>lua require('telescope.builtin').find_files({previewer = false})<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader><space>', [[<cmd>lua require('telescope.builtin').buffers()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sf', [[<cmd>lua require('telescope.builtin').find_files({previewer = false})<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sb', [[<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sd', [[<cmd>lua require('telescope.builtin').grep_string()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sp', [[<cmd>lua require('telescope.builtin').live_grep()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>?', [[<cmd>lua require('telescope.builtin').oldfiles()<CR>]], { noremap = true, silent = true })

-- Treesitter configuration
-- Parsers must be installed manually via :TSInstall
require('nvim-treesitter.configs').setup {
	highlight = {
		enable = true, -- false will disable the whole extension
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = 'gnn',
			node_incremental = 'grn',
			scope_incremental = 'grc',
			node_decremental = 'grm',
		},
	},
	indent = {
		enable = true,
	},
	textobjects = {
		select = {
			enable = true,
			lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				['af'] = '@function.outer',
				['if'] = '@function.inner',
				['ac'] = '@class.outer',
				['ic'] = '@class.inner',
			},
		},
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				[']m'] = '@function.outer',
				[']]'] = '@class.outer',
			},
			goto_next_end = {
				[']M'] = '@function.outer',
				[']['] = '@class.outer',
			},
			goto_previous_start = {
				['[m'] = '@function.outer',
				['[['] = '@class.outer',
			},
			goto_previous_end = {
				['[M'] = '@function.outer',
				['[]'] = '@class.outer',
			},
		},
	},
}

-- LSP settings
local nvim_lsp = require 'lspconfig'
local on_attach = function(_, bufnr)
	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

	local opts = { noremap = true, silent = true }
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
	-- vim.api.nvim_buf_set_keymap(bufnr, 'v', '<leader>ca', '<cmd>lua vim.lsp.buf.range_code_action()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>so', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]], opts)
	vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]
end

-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- Enable the following language servers
local servers = { 'gopls' }
for _, lsp in ipairs(servers) do
	nvim_lsp[lsp].setup {
		on_attach = on_attach,
		capabilities = capabilities,
	}
end

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
	snippet = {
		expand = function(args)
			require('luasnip').lsp_expand(args.body)
		end,
	},
	formatting = {
		format = require('lspkind').cmp_format(),
	},
	mapping = {
		['<C-p>'] = cmp.mapping.select_prev_item(),
		['<C-n>'] = cmp.mapping.select_next_item(),
		['<C-d>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.close(),
		['<CR>'] = cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		},
		['<Tab>'] = function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			else
				fallback()
			end
		end,
	},
	sources = {
		{ name = 'nvim_lsp' },
		{ name = 'treesitter' },
		{ name = 'luasnip' },
		{ name = 'path' },
	},
}
