local g = vim.g

g.mapleader = " "
g.maplocalleader = " "

local keymap = vim.keymap

local function map(m, k, v, d)
  keymap.set(m, k, v, { silent = true, desc = d })
end


-- Move between windows
-- Navigate vim panes better
map("n", "<c-k>", ":wincmd k<CR>", "Move Down")
map("n", "<c-j>", ":wincmd j<CR>", "Move Up")
map("n", "<c-h>", ":wincmd h<CR>", "Move Left")
map("n", "<c-l>", ":wincmd l<CR>", "Move Right")

map("n", "<leader>h", ":nohlsearch<CR>", "")

-- increment/decrement numbers
map("n", "<leader>+", "<C-a>", "Increment number") -- increment
map("n", "<leader>-", "<C-x>", "Decrement number") -- decrement

-- window management
map("n", "<leader>sv", "<C-w>v", "Split window vertically")                   -- split window vertically
map("n", "<leader>sh", "<C-w>s", "Split window horizontally")                 -- split window horizontally
map("n", "<leader>se", "<C-w>=", "Make splits equal size")                    -- make split windows equal width & height
map("n", "<leader>sx", "<cmd>close<CR>", "Close current split")               -- close current split window

map("n", "<leader>to", "<cmd>tabnew<CR>", "Open new tab")                     -- open new tab
map("n", "<leader>tx", "<cmd>tabclose<CR>", "Close current tab")              -- close current tab
map("n", "<leader>tn", "<cmd>tabn<CR>", "Go to next tab")                     --  go to next tab
map("n", "<leader>tp", "<cmd>tabp<CR>", "Go to previous tab")                 --  go to previous tab
map("n", "<leader>tf", "<cmd>tabnew %<CR>", "Open current buffer in new tab") --  move current buffer to new tab
