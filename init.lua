-- NOTE: Throughout this config, some plugins are
-- disabled by default. This is because I don't use
-- them on a daily basis, but I still want to keep
-- them around as examples.
-- You can enable them by changing `enabled = false`
-- to `enabled = true` in the respective plugin spec.
-- Some of these also have the
-- PERF: (performance) comment, which
-- indicates that I found them to slow down the config.
-- (may be outdated with newer versions of the plugins,
-- check for yourself if you're interested in using them)
-- snip-next-choice
require 'config.global'
require 'config.lazy'
require 'config.autocommands'
require 'config.redir'

vim.cmd[[colorscheme catppuccin-latte]]
vim.o.tabstop = 2 -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 2 -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 2

vim.cmd([[
  augroup tuck
    autocmd!
    autocmd tuck BufWritePost mod*.tex !tectonic -X compile % --synctex --keep-logs --keep-intermediates && cp %:s?tex?pdf? ./_site/%:s?tex?pdf?:s?mod??
  augroup END
]])

require("dap").adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
        command = "codelldb",
        args = { "--port", "${port}" },
    },
}

require("dap").configurations.c = {
      {
        name = "C Debug And Run",
        type = "codelldb",
        request = "launch",
        args = function ()
          return { vim.fn.input("Program CLI args:", "./urls.txt.orig") }
        end,
        program = function()
          -- local cwd = vim.fn.getcwd()
          -- if (file.exists(cwd, "Makefile")) then
          -- Todo. Then invoke make commands
          -- Then ask user to provide execute file
            os.execute("make")
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          -- else
            -- return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            -- local fileName = vim.fn.expand("%:t:r")
            -- if (not file.exists(cwd, "bin")) then
            --   -- create this directory
            --   os.execute("mkdir " .. "bin")
            -- end
            -- local cmd = "!gcc -g % -o bin/" .. fileName
            -- -- First, compile it
            -- vim.cmd(cmd)
            -- -- Then, return it
            -- return "${fileDirname}/bin/" .. fileName
          -- end
        end,
        cwd = "${fileDirname}",
        stopOnEntry = false
      },
    }

