return {
    {
        "craftzdog/solarized-osaka.nvim",
        name = "solarized-osaka",
        lazy = true,
        opts = function()
            return {
                transparent = true,
            }
        end,
    },

    { "ellisonleao/gruvbox.nvim", name = "gruvbox", lazy = "true", priority = 1000 },
}
