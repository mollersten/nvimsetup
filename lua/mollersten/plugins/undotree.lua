return {
    "mbbill/undotree",
    keys = { { "<leader>u", vim.cmd.UndotreeToggle, desc = "Undo tree" } },
    init = function()
        vim.opt.undofile = true
        vim.opt.undodir = vim.fn.stdpath("state") .. "/undo"
    end,
}
