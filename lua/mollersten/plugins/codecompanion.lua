return {
    "olimorris/codecompanion.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "ravitemer/mcphub.nvim",
    },
    config = function()
        require("codecompanion").setup({
            opts = {
                log_level = "DEBUG",
            },
            -- 1. Changed 'strategies' to 'interactions'
            interactions = {
                chat = {
                    adapter = "anthropic",
                    model = "claude-opus-4-6", -- 2. Moved model declaration here
                },
                inline = {
                    adapter = "anthropic",
                    model = "claude-opus-4-6",
                },
                cmd = {
                    adapter = "anthropic",
                    model = "claude-opus-4-6",
                },
            },
            adapters = {
                anthropic = function()
                    return require("codecompanion.adapters").extend("anthropic", {
                        env = {
                            api_key = vim.env.ANTHROPIC_API_KEY,
                        },
                        -- You can safely keep your custom headers and caching options here
                        headers = {
                            ["anthropic-beta"] = "prompt-caching-2024-07-31",
                            -- ["anthropic-beta"] = "context-1m-2025-08-07"
                        },
                        opts = {
                            enable_caching = true,
                        },
                    })
                end,
            },
            display = {
                chat = {
                    window = {
                        layout = "vertical",
                        position = "right",
                        width = 0.4,
                    },
                },
            },
            extensions = {
                mcphub = {
                    callback = "mcphub.extensions.codecompanion",
                    opts = {
                        -- MCP Tools
                        make_tools = true,                    -- Make individual tools (@server__tool) and server groups (@server) from MCP servers
                        show_server_tools_in_chat = true,     -- Show individual tools in chat completion (when make_tools=true)
                        add_mcp_prefix_to_tool_names = false, -- Add mcp__ prefix (e.g `@mcp__github`, `@mcp__neovim__list_issues`)
                        show_result_in_chat = true,           -- Show tool results directly in chat buffer
                        format_tool = nil,                    -- function(tool_name:string, tool: CodeCompanion.Agent.Tool) : string Function to format tool names to show in the chat buffer
                        -- MCP Resources
                        make_vars = false,                    -- Disabled: mcphub not yet updated for interactions rename (was strategies)
                        -- MCP Prompts
                        make_slash_commands = true,           -- Add MCP prompts as /slash commands
                    }
                }
            }
        })
    end,
    keys = {
        { "<leader>cc", "<cmd>CodeCompanionChat<cr>",    mode = "n",          desc = "CodeCompanion Chat" },
        { "<leader>cc", "<cmd>CodeCompanionChat<cr>",    mode = "v",          desc = "CodeCompanion Chat" },
        { "<leader>ch", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "CodeCompanion Actions" },
        { "<leader>co", "<cmd>CodeCompanion<cr>",        mode = { "n", "v" }, desc = "CodeCompanion Inline" },
    },
}
