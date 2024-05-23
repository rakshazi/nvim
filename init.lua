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
	use 'NoahTheDuke/vim-just' -- justfile support

	-- features
	use 'axelf4/vim-strip-trailing-whitespace' -- remove trailing whitespaces on changed lines only
	use 'sheerun/vim-polyglot' -- identation
	use 'numToStr/Comment.nvim' -- comments
	use 'JoosepAlviste/nvim-ts-context-commentstring' -- correct comments in files with multiple languages
	use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
	use 'hrsh7th/cmp-nvim-lsp' -- cmp source: nvim lsp
	use 'hrsh7th/cmp-path' -- cmp source: system paths
	use 'ray-x/cmp-treesitter' -- cmp source: treesitter
	use 'saadparwaiz1/cmp_luasnip' -- cmp source: luasnip
	use 'onsails/lspkind-nvim' -- type icons for cmp suggestions
	use 'L3MON4D3/LuaSnip' -- Snippets plugin
	use 'mzlogin/vim-markdown-toc' -- markdown ToC generator
	use 'preservim/tagbar' -- tagbar
	use 'github/copilot.vim' -- copilot
	use 'panozzaj/vim-copilot-ignore' -- .copilotignore support
	use 'rcarriga/nvim-notify' -- notifications

	-- UI
	use 'navarasu/onedark.nvim' -- colorscheme
	use { "catppuccin/nvim", as = "catppuccin" } -- colorscheme
	use 'https://git.sr.ht/~whynothugo/lsp_lines.nvim' -- lsp diagnostig with line guides
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

-- notifications
vim.notify = require("notify")

-- Incremental live completion (note: this is now a default on master)
vim.o.inccommand = 'nosplit'

-- disable mouse
vim.o.mouse = ''

-- Spellcheck
vim.o.spell = true
vim.o.spelllang = 'en_us'

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

-- Copilot
vim.g.copilot_assume_mapped = true

-- Set colorscheme
vim.cmd.colorscheme "catppuccin-macchiato"
require("catppuccin").setup({
	integrations = {
		cmp = true,
		gitsigns = true,
		nvimtree = true,
		treesitter = true,
		notify = true,
	}
})
vim.opt.termguicolors = true
-- require('onedark').setup{
-- 	style = 'darker'
-- }
-- require('onedark').load()

-- Set bufferline
require("bufferline").setup{
	highlights = require("catppuccin.groups.integrations.bufferline").get(),
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
	options = { theme = 'catppuccin' },
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

-- Tagbar
vim.api.nvim_set_keymap('n', '<F8>', ':TagbarToggle<CR>', { noremap = true, silent = true })
vim.g.tagbar_autofocus = 1
vim.g.tagbar_autoclose = 1

-- Highlight on yank
vim.api.nvim_exec([[
augroup YankHighlight
autocmd!
autocmd TextYankPost * silent! lua vim.highlight.on_yank()
augroup end
]], false)

-- Characters list
vim.opt.list = true
vim.opt.listchars:append "space: "
vim.opt.listchars:append "lead:⋅"
vim.opt.listchars:append "trail:⋅"
vim.opt.listchars:append "multispace:⋅"
vim.opt.listchars:append "leadmultispace:⋅"
vim.opt.listchars:append "tab:⭾⋅"

-- Map blankline
vim.cmd [[highlight IndentBlanklineContextStart guisp=#000000 gui=nocombine]]
require("ibl").setup()

-- show diagnostic information with line guides
require("lsp_lines").setup()
-- Disable virtual_text since it's redundant due to lsp_lines.
vim.diagnostic.config({
		virtual_text = false,
	})

-- nerdtree-like
local function on_attach(bufnr)
	local api = require('nvim-tree.api')

	local function opts(desc)
		return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end


	-- Default mappings. Feel free to modify or remove as you wish.
	--
	-- BEGIN_DEFAULT_ON_ATTACH
	vim.keymap.set('n', '<C-]>', api.tree.change_root_to_node,          opts('CD'))
	vim.keymap.set('n', '<C-e>', api.node.open.replace_tree_buffer,     opts('Open: In Place'))
	vim.keymap.set('n', '<C-k>', api.node.show_info_popup,              opts('Info'))
	vim.keymap.set('n', '<C-r>', api.fs.rename_sub,                     opts('Rename: Omit Filename'))
	vim.keymap.set('n', '<C-t>', api.node.open.tab,                     opts('Open: New Tab'))
	vim.keymap.set('n', '<C-v>', api.node.open.vertical,                opts('Open: Vertical Split'))
	vim.keymap.set('n', '<C-x>', api.node.open.horizontal,              opts('Open: Horizontal Split'))
	vim.keymap.set('n', '<BS>',  api.node.navigate.parent_close,        opts('Close Directory'))
	vim.keymap.set('n', '<CR>',  api.node.open.edit,                    opts('Open'))
	vim.keymap.set('n', '<Tab>', api.node.open.preview,                 opts('Open Preview'))
	vim.keymap.set('n', '>',     api.node.navigate.sibling.next,        opts('Next Sibling'))
	vim.keymap.set('n', '<',     api.node.navigate.sibling.prev,        opts('Previous Sibling'))
	vim.keymap.set('n', '.',     api.node.run.cmd,                      opts('Run Command'))
	vim.keymap.set('n', '-',     api.tree.change_root_to_parent,        opts('Up'))
	vim.keymap.set('n', 'a',     api.fs.create,                         opts('Create'))
	vim.keymap.set('n', 'bmv',   api.marks.bulk.move,                   opts('Move Bookmarked'))
	vim.keymap.set('n', 'B',     api.tree.toggle_no_buffer_filter,      opts('Toggle No Buffer'))
	vim.keymap.set('n', 'c',     api.fs.copy.node,                      opts('Copy'))
	vim.keymap.set('n', 'C',     api.tree.toggle_git_clean_filter,      opts('Toggle Git Clean'))
	vim.keymap.set('n', '[c',    api.node.navigate.git.prev,            opts('Prev Git'))
	vim.keymap.set('n', ']c',    api.node.navigate.git.next,            opts('Next Git'))
	vim.keymap.set('n', 'd',     api.fs.remove,                         opts('Delete'))
	vim.keymap.set('n', 'D',     api.fs.trash,                          opts('Trash'))
	vim.keymap.set('n', 'E',     api.tree.expand_all,                   opts('Expand All'))
	vim.keymap.set('n', 'e',     api.fs.rename_basename,                opts('Rename: Basename'))
	vim.keymap.set('n', ']e',    api.node.navigate.diagnostics.next,    opts('Next Diagnostic'))
	vim.keymap.set('n', '[e',    api.node.navigate.diagnostics.prev,    opts('Prev Diagnostic'))
	vim.keymap.set('n', 'F',     api.live_filter.clear,                 opts('Clean Filter'))
	vim.keymap.set('n', 'f',     api.live_filter.start,                 opts('Filter'))
	vim.keymap.set('n', 'g?',    api.tree.toggle_help,                  opts('Help'))
	vim.keymap.set('n', 'gy',    api.fs.copy.absolute_path,             opts('Copy Absolute Path'))
	vim.keymap.set('n', 'H',     api.tree.toggle_hidden_filter,         opts('Toggle Dotfiles'))
	vim.keymap.set('n', 'I',     api.tree.toggle_gitignore_filter,      opts('Toggle Git Ignore'))
	vim.keymap.set('n', 'J',     api.node.navigate.sibling.last,        opts('Last Sibling'))
	vim.keymap.set('n', 'K',     api.node.navigate.sibling.first,       opts('First Sibling'))
	vim.keymap.set('n', 'm',     api.marks.toggle,                      opts('Toggle Bookmark'))
	vim.keymap.set('n', 'o',     api.node.open.edit,                    opts('Open'))
	vim.keymap.set('n', 'O',     api.node.open.no_window_picker,        opts('Open: No Window Picker'))
	vim.keymap.set('n', 'p',     api.fs.paste,                          opts('Paste'))
	vim.keymap.set('n', 'P',     api.node.navigate.parent,              opts('Parent Directory'))
	vim.keymap.set('n', 'q',     api.tree.close,                        opts('Close'))
	vim.keymap.set('n', 'r',     api.fs.rename,                         opts('Rename'))
	vim.keymap.set('n', 'R',     api.tree.reload,                       opts('Refresh'))
	vim.keymap.set('n', 's',     api.node.run.system,                   opts('Run System'))
	vim.keymap.set('n', 'S',     api.tree.search_node,                  opts('Search'))
	vim.keymap.set('n', 'U',     api.tree.toggle_custom_filter,         opts('Toggle Hidden'))
	vim.keymap.set('n', 'W',     api.tree.collapse_all,                 opts('Collapse'))
	vim.keymap.set('n', 'x',     api.fs.cut,                            opts('Cut'))
	vim.keymap.set('n', 'y',     api.fs.copy.filename,                  opts('Copy Name'))
	vim.keymap.set('n', 'Y',     api.fs.copy.relative_path,             opts('Copy Relative Path'))
	vim.keymap.set('n', '<2-LeftMouse>',  api.node.open.edit,           opts('Open'))
	vim.keymap.set('n', '<2-RightMouse>', api.tree.change_root_to_node, opts('CD'))
	-- END_DEFAULT_ON_ATTACH


	-- Mappings migrated from view.mappings.list
	--
	-- You will need to insert "your code goes here" for any mappings with a custom action_cb
	vim.keymap.set('n', '<C-e>', api.tree.close, opts('Close'))

end
vim.api.nvim_set_keymap('', '<C-e>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
require('nvim-tree').setup {
	hijack_cursor = true,
	renderer = {
		highlight_git = true,
		special_files = {}
	},
	actions = {
		open_file = {
			quit_on_open = true,
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
	on_attach = on_attach,
}

-- Comment for comments
require('Comment').setup()
-- adjust treesitter commentstring based on the programming language used in that specific line
require('ts_context_commentstring').setup()

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
require('telescope').load_extension('fzf')
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
nvim_lsp['native_lsp'] = {
    enabled = true,
    virtual_text = {
        errors = { "italic" },
        hints = { "italic" },
        warnings = { "italic" },
        information = { "italic" },
    },
    underlines = {
        errors = { "underline" },
        hints = { "underline" },
        warnings = { "underline" },
        information = { "underline" },
    },
    inlay_hints = {
        background = true,
    },
}
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
local capabilities = require('cmp_nvim_lsp').default_capabilities()

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
