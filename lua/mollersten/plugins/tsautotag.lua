return {
    'windwp/nvim-ts-autotag',
    ft = { "html", "xml", "javascript", "typescript", "tsx", "vue" }, -- lazy load on filetypes
    config = function()
        require('nvim-ts-autotag').setup({
            enable_close = true,
            enable_rename = true,
            enable_close_on_slash = false,
            per_filetype = {
                html = {
                    enable_close = false
                }
            }
        })
    end
}
