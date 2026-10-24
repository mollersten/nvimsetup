return {
    "williamboman/mason.nvim",
    require("mason").setup({
        registries = {
            "github:mason-org/mason-registry",
            "github:Crashdummyy/mason-registry",
        },
    })
}
