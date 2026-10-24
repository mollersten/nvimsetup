return {
    'nvim-treesitter/nvim-treesitter',
    branch = "main", -- 'master' does not support Neovim 0.12
    lazy = false,    -- 'main' does not support lazy-loading
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter").install({ "c_sharp", "php", "ocaml", "ocaml_interface", "ocamllex", "typescript", "tsx", "rust", "toml", "c", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html", "markdown", "markdown_inline" })

        -- 'main' no longer enables highlight/indent itself; start them for any filetype with a parser
        vim.api.nvim_create_autocmd("FileType", {
            callback = function(args)
                if not pcall(vim.treesitter.start, args.buf) then
                    return
                end
                local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
                if lang and vim.treesitter.query.get(lang, "indents") then
                    vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end
            end,
        })
    end
}
