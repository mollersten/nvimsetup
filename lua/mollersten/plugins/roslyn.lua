return {
    "seblj/roslyn.nvim",
    ft = { "cs" }, -- Ladda bara pluginet när du öppnar C#-filer
    config = function()
        -- Hämta Blink.cmp-inställningarna så att autocompletion fungerar
        local capabilities = require('blink.cmp').get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())

        require("roslyn").setup({
            config = {
                capabilities = capabilities,
                -- Här kan du lägga till specifik formatering om du vill senare
                settings = {
                    ["csharp|inlay_hints"] = {
                        csharp_enable_inlay_hints_for_implicit_variable_types = true,
                        csharp_enable_inlay_hints_for_types = true,
                    },
                },
            },
            -- Låter pluginet leta efter din .sln-fil automatiskt
            exe = {
                "dotnet",
                vim.fn.stdpath("data") .. "/roslyn/Microsoft.CodeAnalysis.LanguageServer.dll",
            },
        })
    end
}
