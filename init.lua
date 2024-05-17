-- TODO:
-- Weird delay when selecting down one in line mode
-- Testing support for jest
-- Automatically watch all tests on startup

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local function runPrettier()
    vim.cmd('silent !prettier --write %')
    vim.notify("Ran prettier")
end

vim.keymap.set('n', '<leader>p', runPrettier, {
    desc = "Run prettier on the current buffer",
})
vim.api.nvim_set_keymap('i', 'jk', '<Esc>', {})
vim.keymap.set("t", "jk", "<C-\\><C-n>")
vim.api.nvim_create_user_command("W", "w", {})

-- Cool settings
vim.opt.relativenumber = true
vim.opt.autowriteall = true
vim.opt.autowrite = true

vim.opt.wrap = false
vim.opt.incsearch = true
vim.opt.hlsearch = false
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.updatetime = 50
vim.opt.colorcolumn = "80"
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")

vim.keymap.set('n', '<C-j>', '<C-w><C-j>', {})
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', {})
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', {})
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', {})


-- [[ Install `lazy.nvim` plugin manager ]]
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    }
end
vim.opt.rtp:prepend(lazypath)

-- [[ Configure plugins ]]
-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require('lazy').setup({
    'lsp-config',
    'epwalsh/obsidian.nvim',
    'tpope/vim-rhubarb',
    'j-hui/fidget.nvim',
    -- Detect tabstop and shiftwidth automatically
    'tpope/vim-sleuth',
    { 'rose-pine/neovim', name = 'rose-pine' },
    -- "gc" to comment visual regions/lines
    { 'numToStr/Comment.nvim', opts = {} },

    {
        'tpope/vim-fugitive',
        init = function()
            vim.keymap.set('n', '<leader>gs', function()
                vim.cmd('vert Git');
            end)
        end
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        }
    },

    -- NOTE: This is where your plugins related to LSP can be installed.
    --  The configuration is done below. Search for lspconfig to find it below.
    {
        -- LSP Configuration & Plugins
        'neovim/nvim-lspconfig',
        dependencies = {
            -- Automatically install LSPs to stdpath for neovim
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',

            -- Useful status updates for LSP
            -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
            { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },

            -- Additional lua configuration, makes nvim stuff amazing!
            'folke/neodev.nvim',
        },
    },

    {
        -- Autocompletion
        'hrsh7th/nvim-cmp',
        dependencies = {
            -- Snippet Engine & its associated nvim-cmp source
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',

            -- Adds LSP completion capabilities
            'hrsh7th/cmp-nvim-lsp',

            -- Adds a number of user-friendly snippets
            'rafamadriz/friendly-snippets',
        },
    },

    -- Autoclose brackets and similar
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = true
        -- use opts = {} for passing setup options
        -- this is equalent to setup({}) function
    },

    {
        -- Set lualine as statusline
        'nvim-lualine/lualine.nvim',
        -- See `:help lualine.txt`
        opts = {
            options = {
                icons_enabled = false,
                theme = 'rose-pine',
                component_separators = '|',
                section_separators = '',
            },
        },
    },

    {
        -- Add indentation guides even on blank lines
        'lukas-reineke/indent-blankline.nvim',
        -- Enable `lukas-reineke/indent-blankline.nvim`
        -- See `:help ibl`
        main = 'ibl',
        opts = {},
    },


    -- Fuzzy Finder (files, lsp, etc)
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
            -- Fuzzy Finder Algorithm which requires local dependencies to be built.
            -- Only load if `make` is available. Make sure you have the system
            -- requirements installed.
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                -- NOTE: If you are having trouble with this installation,
                --       refer to the README for telescope-fzf-native for more instructions.
                build = 'make',
                cond = function()
                    return vim.fn.executable 'make' == 1
                end,
            },
        },
    },

    {
        -- Highlight, edit, and navigate code
        'nvim-treesitter/nvim-treesitter',
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        build = ':TSUpdate',
    },

    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" }
    },

    {
        'akinsho/flutter-tools.nvim',
        lazy = false,
        dependencies = {
            'nvim-lua/plenary.nvim',
            'stevearc/dressing.nvim', -- optional for vim.ui.select
        },
    },

    -- Put vim marks in the gutter
    'chentoast/marks.nvim',

    -- Annotate git changes in the gutter
    'lewis6991/gitsigns.nvim',

    -- Shows side pannel during git operations
    -- And some nice 3 panel views?
    'sindrets/diffview.nvim',

    -- Autoclose xml tags
    'windwp/nvim-ts-autotag',

    {
        "mfussenegger/nvim-jdtls",
        dependencies = {
            'mfussenegger/nvim-dap',
        }
    },

    {
        'mrcjkb/rustaceanvim',
        version = '^4',
        lazy = false, -- This plugin is already lazy
    },

    -- TODO: Learn how to use it
    {
        'saecki/crates.nvim',
        tag = 'stable',
        config = function()
            require('crates').setup()
        end,
    },

    'nvim-tree/nvim-web-devicons',
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            multiline = false,
            padding = false,
            icons = false,
        },
    },

    -- Sessions
    -- TODO: I just picked this one because it was quiet.
    'rmagatti/auto-session',

    'tpope/vim-surround',

    {
        'mbbil/undotree',
        init = function()
            vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
        end
    },

    -- Tests
    {
        "rcasia/neotest-java",
        -- init = function()
        --     -- override the default keymaps.
        --     -- needed until neotest-java is integrated in LazyVim
        --     local keys = require("lazyvim.plugins.lsp.keymaps").get()
        --     -- run test file
        --     keys[#keys + 1] = { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, mode = "n" }
        --     -- run nearest test
        --     keys[#keys + 1] = { "<leader>tr", function() require("neotest").run.run() end, mode = "n" }
        --     -- debug test file
        --     keys[#keys + 1] = { "<leader>tD", function() require("jdtls.dap").test_class() end, mode = "n" }
        --     -- debug nearest test
        --     keys[#keys + 1] = { "<leader>td", function() require("jdtls.dap").test_nearest_method() end, mode = "n" }
        -- end
    },
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
            "marilari88/neotest-vitest",
            "weilbith/neotest-gradle",
            'nvim-neotest/neotest-jest',
        },
        config = function()
            require("neotest").setup({
                adapters = {
                    require("neotest-vitest"),
                    require("neotest-gradle"),
                    require('neotest-jest')({
                        jestCommand = "npm test --",
                        jestConfigFile = "custom.jest.config.ts",
                        env = { CI = true },
                        cwd = function(path)
                            return vim.fn.getcwd()
                        end,
                    }),
                }
            })
        end,
    },
    {
    },

    require 'kickstart.plugins.autoformat',
    require 'kickstart.plugins.debug',
    'theHamsta/nvim-dap-virtual-text',
    'Weissle/persistent-breakpoints.nvim',

}, {})

vim.g.rustaceanvim = {
    tools = {
        -- test_executor = "background"
    },
    default_settings = {
        -- rust-analyzer langauge server configuration
        ['rust-analyzer'] = {

        },
    },
    dap = {

    },
}

require('neotest').setup {
    adapters = {
        require('rustaceanvim.neotest')
    },
}

require("auto-session").setup {
    log_level = "error",
    auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
}

-- Test Shortcuts
local neotest = require('neotest')
vim.keymap.set("n", "<leader>tr", function() neotest.run.run() end, { desc = "[T]est [R]un Nearest" })
vim.keymap.set("n", "<leader>trf", function() neotest.run.run(vim.fn.expand("%")) end, { desc = "[T]est [F]ile" })
vim.keymap.set("n", "<leader>trm", function() neotest.summary.run_marked() end,
    { desc = "[T]est [S]ummary run [M]arked" })
vim.keymap.set("n", "<leader>td", function() neotest.run.run({ strategy = "dap" }) end,
    { desc = "[T]est [D]ebug nearest" })
vim.keymap.set("n", "<leader>ts", function() neotest.run.stop() end, { desc = "[T]est [S]top" })

vim.keymap.set("n", "<leader>tw", function() neotest.watch.watch() end, { desc = "[T]est [W]atch" })
vim.keymap.set("n", "<leader>twf", function() neotest.watch.watch(vim.fn.expand("%")) end,
    { desc = "[T]est [W]atch [F]ile" })
vim.keymap.set("n", "<leader>tws", function() neotest.watch.stop() end, { desc = "[T]est [W]atch [S]top" })
vim.keymap.set("n", "<leader>twsf", function() neotest.watch.stop() end, { desc = "[T]est [W]atch [S]top [F]ile" })

vim.keymap.set("n", "<leader>ts", function() neotest.summary.toggle() end, { desc = "[T]est [S]ummary toggle" })
vim.keymap.set("n", "<leader>tp", function() neotest.output_panel.toggle() end, { desc = "[T]est [P]anel" })

require("nvim-dap-virtual-text").setup {}
require('persistent-breakpoints').setup {
    load_breakpoints_event = { "BufReadPost" }
}
-- Harpoon2
local harpoon = require("harpoon")
harpoon:setup({})

vim.keymap.set("n", "<leader>ha", function() harpoon:list():append() end)
vim.keymap.set("n", "<leader>hp", function() harpoon:list():prepend() end)
vim.keymap.set("n", "<leader>h", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

vim.keymap.set("n", "<leader>h1", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<leader>h2", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<leader>h3", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<leader>h4", function() harpoon:list():select(4) end)
vim.keymap.set("n", "<leader>h5", function() harpoon:list():select(5) end)
vim.keymap.set("n", "<leader>h6", function() harpoon:list():select(6) end)
vim.keymap.set("n", "<leader>h7", function() harpoon:list():select(7) end)
vim.keymap.set("n", "<leader>h8", function() harpoon:list():select(8) end)
vim.keymap.set("n", "<leader>h9", function() harpoon:list():select(9) end)

-- Autoclose
-- require('nvim-autopairs').setup({
--   disable_filetype = { "TelescopePrompt" , "vim" },
-- })

-- Setup language servers.
local lspconfig = require('lspconfig')
lspconfig.pyright.setup {}
lspconfig.tsserver.setup {}
local pid = vim.fn.getpid()
lspconfig.omnisharp.setup {
    cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(pid) },
}
lspconfig.clangd.setup {}
lspconfig.stylelint_lsp.setup {
    settings = {
        stylelintplus = {
            -- see available options in stylelint-lsp documentation
        }
    }
}

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', function()
    vim.cmd "Trouble"
end, { desc = 'Open Trouble' })
vim.keymap.set('n', '<leader>Q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
local telescope_actions = require('telescope.actions')
local trouble = require("trouble.providers.telescope")
require('telescope').setup {
    defaults = {
        mappings = {
            i = {
                ['<C-k>'] = telescope_actions.move_selection_previous,
                ['<C-j>'] = telescope_actions.move_selection_next,
                ["<C-t>"] = trouble.open_with_trouble,
            },
            n = {
                ["<C-t>"] = trouble.open_with_trouble,
            },
        },
    },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- Telescope live_grep in git root
-- Function to find the git root directory based on the current buffer's path
local function find_git_root()
    -- Use the current buffer's path as the starting point for the git search
    local current_file = vim.api.nvim_buf_get_name(0)
    local current_dir
    local cwd = vim.fn.getcwd()
    -- If the buffer is not associated with a file, return nil
    if current_file == "" then
        current_dir = cwd
    else
        -- Extract the directory from the current file's path
        current_dir = vim.fn.fnamemodify(current_file, ":h")
    end

    -- Find the Git root directory from the current file's path
    local git_root = vim.fn.systemlist("git -C " .. vim.fn.escape(current_dir, " ") .. " rev-parse --show-toplevel")[1]
    if vim.v.shell_error ~= 0 then
        print("Not a git repository. Searching on current working directory")
        return cwd
    end
    return git_root
end

-- Custom live_grep function to search in git root
local function live_grep_git_root()
    local git_root = find_git_root()
    if git_root then
        require('telescope.builtin').live_grep({
            search_dirs = { git_root },
        })
    end
end

vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
    -- You can pass additional configuration to telescope to change theme, layout, etc.
    require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        previewer = false,
    })
end, { desc = '[/] Fuzzily search in current buffer' })

local function find_file()
    require('telescope.builtin').find_files({ hidden = false })
end

vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', find_file, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sG', ':LiveGrepGitRoot<cr>', { desc = '[S]earch by [G]rep on Git Root' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
-- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
vim.defer_fn(function()
    require('nvim-treesitter.configs').setup {
        autotag = {
            enable = true,
        },
        -- add languages to be installed here that you want installed for treesitter
        ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'javascript', 'typescript', 'vimdoc', 'vim', 'bash', 'java', 'kotlin', 'rust', 'html', 'css' },

        -- autoinstall languages that are not installed. defaults to false (but you can change for yourself!)
        auto_install = true,

        highlight = { enable = true },
        indent = { enable = true },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = '<c-space>',
                node_incremental = '<c-space>',
                scope_incremental = '<c-s>',
                node_decremental = '<m-space>',
            },
        },
        textobjects = {
            select = {
                enable = true,
                lookahead = true, -- automatically jump forward to textobj, similar to targets.vim
                keymaps = {
                    -- you can use the capture groups defined in textobjects.scm
                    ['aa'] = '@parameter.outer',
                    ['ia'] = '@parameter.inner',
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
                    [']m'] = '@function.outer',
                    [']['] = '@class.outer',
                },
                goto_previous_start = {
                    ['[m'] = '@function.outer',
                    ['[['] = '@class.outer',
                },
                goto_previous_end = {
                    ['[m'] = '@function.outer',
                    ['[]'] = '@class.outer',
                },
            },
            swap = {
                enable = true,
                swap_next = {
                    ['<leader>a'] = '@parameter.inner',
                },
                swap_previous = {
                    ['<leader>a'] = '@parameter.inner',
                },
            },
        },
    }
end, 0)

-- Configure Autotag for xml
require('nvim-ts-autotag').setup()

vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    {
        underline = true,
        virtual_text = {
            spacing = 5,
        },
        update_in_insert = true,
    }
)

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
function on_attach(_, bufnr)
    -- NOTE: Remember that lua is a real programming language, and as such it is possible
    -- to define small helper and utility functions so you don't have to repeat yourself
    -- many times.
    --
    -- In this case, we create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local nmap = function(keys, func, desc)
        if desc then
            desc = 'LSP: ' .. desc
        end

        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end

    nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

    nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
    nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
    nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
    nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
    nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

    -- See `:help K` for why this keymap
    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

    -- Lesser used LSP functionality
    nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
    nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
    nmap('<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, '[W]orkspace [L]ist Folders')

    if bufnr == nil then
        return
    end
    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format()
    end, { desc = 'Format current buffer with LSP' })
end

-- document existing key chains
require('which-key').register {
    ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
    ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
    ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
    ['<leader>h'] = { name = 'More git', _ = 'which_key_ignore' },
    ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
    ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
    ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
}

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require('mason').setup()
require('mason-lspconfig').setup()

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
    clangd = {},
    gopls = {},
    pyright = {},
    -- Disabled to avoid conflicts with the rust plugin
    -- rust_analyzer = {},
    tsserver = {},
    html = { filetypes = { 'html', 'twig', 'hbs' } },
    jdtls = {},
    kotlin_language_server = {},
    grammarly = {},
    -- Ada
    als = {},
    arduino_language_server = {},
    bashls = {},
    cmake = {},
    htmx = {},
    jsonls = {},
    -- Php
    intelephense = {},
    sqlls = {},
    taplo = {},
    zls = {},
    lemminx = {},
    omnisharp = {},
    csharp_ls = {},
    -- ltex = {},
    jqls = {},

    lua_ls = {
        Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
        },
    },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
    ensure_installed = vim.tbl_keys(servers),
    automatic_installation = true,
}

mason_lspconfig.setup_handlers({
    function(server_name)
        require('lspconfig')[server_name].setup {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = servers[server_name],
            filetypes = (servers[server_name] or {}).filetypes,
        }
    end,
    -- Java is special because we have the java plugin.
    -- Auto initialization of the lsp doesn't work well,
    -- skip it, we handle it in ftplugin/java.lua
    ['jdtls'] = function() end,
    ['rust_analyzer'] = function() end,
})

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
-- luasnip.config.setup {}

cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert {
        ['<C-j>'] = cmp.mapping.select_next_item(),
        ['<C-k>'] = cmp.mapping.select_prev_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-n>'] = cmp.mapping.complete {},
        ['<C-y>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    },
}

-- Sets the background transparent
-- Doesn't seem to work. Issue with Wayland and KWin?
function ColorMyPencils(color)
    color = color or "rose-pine"
    vim.cmd.colorscheme(color)

    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
    vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "none" })
    vim.api.nvim_set_hl(0, "TroubleNormal", { bg = "none" })
end

ColorMyPencils()

require 'marks'.setup {
    -- whether to map keybinds or not. default true
    default_mappings = true,
    -- which builtin marks to show. default {}
    -- builtin_marks = { ".", "<", ">", "^" },
    -- whether movements cycle back to the beginning/end of buffer. default true
    cyclic = true,
    -- whether the shada file is updated after modifying uppercase marks. default false
    force_write_shada = false,
    -- how often (in ms) to redraw signs/recompute mark positions.
    -- higher values will have better performance but may cause visual lag,
    -- while lower values may cause performance penalties. default 150.
    refresh_interval = 250,
    -- sign priorities for each type of mark - builtin marks, uppercase marks, lowercase
    -- marks, and bookmarks.
    -- can be either a table with all/none of the keys, or a single number, in which case
    -- the priority applies to all marks.
    -- default 10.
    sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
    -- disables mark tracking for specific filetypes. default {}
    excluded_filetypes = {},
    -- disables mark tracking for specific buftypes. default {}
    excluded_buftypes = {},
    -- marks.nvim allows you to configure up to 10 bookmark groups, each with its own
    -- sign/virttext. Bookmarks can be used to group together positions and quickly move
    -- across multiple buffers. default sign is '!@#$%^&*()' (from 0 to 9), and
    -- default virt_text is "".
    bookmark_0 = {
        sign = "⚑",
        virt_text = "hello world",
        -- explicitly prompt for a virtual line annotation when setting a bookmark from this group.
        -- defaults to false.
        annotate = false,
    },
    mappings = {}
}

require('gitsigns').setup()

-- Folding
-- vim.opt.foldmethod = "indent"

vim.opt.guicursor = "n-v-c-sm:block-blinkwait5000-blinkon1000-blinkoff400,i-ci-ve:ver25,r-cr-o:hor20"

-- local hl_id = vim.api.nvim_get_hl_id_by_name("Cursor")
-- vim.api.nvim_buf_add_highlight(0, "Cursor", hl_id)
