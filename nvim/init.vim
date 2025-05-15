set clipboard=unnamedplus
syntax on
filetype plugin on
filetype indent on
set number
set relativenumber
set incsearch 
set hlsearch
set softtabstop=4
set shiftwidth=4
set backspace=indent,eol,start
set background=dark
set nowrap

set path+=**
set tags+=./tags

let mapleader="\<Space>"

com Reload source ~/.config/nvim/init.vim
com Edit e ~/.config/nvim/init.vim
com Run !./build/main
com Cmake !cmake -B build/
"set makeprg=make\ -C\ build

" Always use a block cursor
if has('gui_running')
    set guicursor=
else
    autocmd VimEnter,WinEnter * set guicursor=
endif

call plug#begin()

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'bluz71/vim-moonfly-colors', { 'as': 'moonfly' }
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' }
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'supermaven-inc/supermaven-nvim'

call plug#end()

" colorscheme lunaperche
colorscheme moonfly
let g:moonflyTransparent = v:true

if exists("g:neovide")
    let g:neovide_refresh_rate = 60
    set guifont=CaskaydiaCove\ Nerd\ Font:h10
endif


"highlight Normal guibg=none
"highlight NonText guibg=none
"highlight Normal ctermbg=none
"highlight NonText ctermbg=none

nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>

nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

lua << EOF

require'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all" (the listed parsers MUST always be installed)
    ensure_installed = { "c", "lua", "vim" },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true,

    -- List of parsers to ignore installing (or "all")
    ignore_install = { "javascript" },

    ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
    -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

    highlight = {
	enable = true,

	-- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
	-- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
	-- the name of the parser)
	-- list of language that will be disabled
	-- disable = { "c", "rust" },
	-- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
	-- disable = function(lang, buf)
	--     local max_filesize = 100 * 1024 -- 100 KB
	--     local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
	--     if ok and stats and stats.size > max_filesize then
	--         return true
	--     end
	-- end,

	-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
	-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
	-- Using this option may slow down your editor, and you may see some duplicate highlights.
	-- Instead of true it can also be a list of languages
	additional_vim_regex_highlighting = false,
    },
}

vim.filetype.add({
  extension = {
    ll = "llvm",
  },
})

require("mason").setup()
require("mason-lspconfig").setup()

require("mason-lspconfig").setup_handlers {
    function (server_name)
	require("lspconfig")[server_name].setup {
	    capabilities = capabilities,
	}
    end,
}

require("supermaven-nvim").setup({})

local opts = { noremap = true, silent = true }
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
-- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
vim.keymap.set('n', '<space>wl', function()
print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, opts)
vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

EOF
