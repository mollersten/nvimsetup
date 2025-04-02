return {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
        require("mason-lspconfig").setup({
            automatic_installation = true,
        })
    end,
}
