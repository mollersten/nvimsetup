-- lua/plugins/rust.lua
return {
    "mrcjkb/rustaceanvim",
    version = "^6",
    ft = { "rust" },
    dependencies = { "mfussenegger/nvim-dap" },
    init = function()
        -- Make sure Neovim sees cargo/rustup on PATH (helpful on macOS/GUI shells).
        -- On Windows, replace ":" with ";" and adjust the path to %USERPROFILE%\.cargo\bin
        local home = vim.fn.expand("~")
        if vim.fn.has("win32") == 1 then
            vim.env.PATH = home .. "\\.cargo\\bin;" .. vim.env.PATH
        else
            vim.env.PATH = home .. "/.cargo/bin:" .. vim.env.PATH
        end

        -- Capabilities (Blink if present; otherwise vanilla)
        local ok_blink, blink = pcall(require, "blink.cmp")
        local capabilities = ok_blink
            and blink.get_lsp_capabilities()
            or vim.lsp.protocol.make_client_capabilities()

        -- Decide which rust-analyzer to run:
        local cmd
        if vim.fn.executable("rustup") == 1 then
            -- Use rustup so RA always matches your toolchain
            cmd = { "rustup", "run", "stable", "rust-analyzer" }
        else
            -- Try Mason's rust-analyzer
            local ok_mr, mr = pcall(require, "mason-registry")
            if ok_mr and mr.is_installed("rust-analyzer") then
                cmd = { mr.get_package("rust-analyzer"):get_install_path() .. "/rust-analyzer" }
            elseif vim.fn.executable("rust-analyzer") == 1 then
                -- Fallback to system binary if available
                cmd = { "rust-analyzer" }
            else
                -- Last resort: show a helpful message inside Neovim
                vim.schedule(function()
                    vim.notify(
                        "rust-analyzer not found. Run `rustup component add rust-analyzer rust-src` " ..
                        "or `:MasonInstall rust-analyzer`.",
                        vim.log.levels.ERROR
                    )
                end)
            end
        end

        -- rustaceanvim config (global)
        vim.g.rustaceanvim = {
            server = {
                cmd = cmd,
                capabilities = capabilities,
                -- Reduce update churn while typing
                flags = { debounce_text_changes = 200 },
                -- rust-analyzer settings
                default_settings = {
                    ["rust-analyzer"] = {
                        check = { command = "clippy" },                -- comment out if you prefer plain `check`
                        cargo = { buildScripts = { enable = false } }, -- enable if you need build.rs assists
                        procMacro = { enable = false },                -- enable if you rely on many macros
                        files = { excludeDirs = { "target", ".git", "node_modules", "dist" } },
                    },
                },
                -- Quiet RA logs if they’re noisy
                cmd_env = { RA_LOG = "error" },
            },
        }
    end,
}
