return {
    "neovim/nvim-lspconfig",
    dependencies = {
        'saghen/blink.cmp',
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        {
            "folke/lazydev.nvim",
            opts = {
                library = {
                    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                },
            },
        },
    },
    config = function()
        -- Setup mason first
        require("mason").setup()
        require("mason-lspconfig").setup({
            automatic_installation = true,
        })

        -- Get capabilities from blink.cmp
        local capabilities = require('blink.cmp').get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())

        -- Store vim.lsp.config in a local variable for cleaner code
        local lsp_config = vim.lsp.config

        lsp_config('lua_ls', {
            capabilities = capabilities
        })

        lsp_config('emmet_ls', {
            capabilities = capabilities,
            filetypes = {
                "html", "css", "scss", "javascript", "javascriptreact",
                "typescriptreact", "vue", "svelte", "xml", "xsl", "php"
            },
            init_options = {
                html = {
                    options = {
                        ["bem.enabled"] = true
                    }
                }
            }
        })

        lsp_config('cssls', {
            capabilities = capabilities, -- optional: from cmp_nvim_lsp
            filetypes = { "css", "scss", "less" },
        })

        lsp_config('intelephense', {
            capabilities = capabilities,
            settings = {
                intelephense = {
                    files = {
                        maxSize = 5000000,
                    }
                }
            }
        })

        vim.api.nvim_create_autocmd('LspAttach', {


            callback = function(args)
                local c = vim.lsp.get_client_by_id(args.data.client_id)
                if not c then return end

                if vim.bo[args.buf].filetype == "php" then
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        buffer = args.buf,
                        callback = function()
                            vim.lsp.buf.format({ bufnr = args.buf, async = false })
                        end,
                    })
                    return
                end

                -- Format the current buffer on save
                if c.supports_method('textDocument/formatting') then
                    vim.api.nvim_create_autocmd('BufWritePre', {
                        buffer = args.buf,
                        callback = function()
                            vim.lsp.buf.format({ bufnr = args.buf, id = c.id })
                        end,
                    })
                end
            end,
        })
    end,
}
