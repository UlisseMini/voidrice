" Run `crystal tool format` on save
"let g:crystal_auto_format = 1

set tabstop=2
set expandtab

" General
nn <leader>gb :!crystal build %<cr>
nn <leader>r :!crystal run %<cr>

" Navigation
nn <leader>gh :CrystalHierarchy<space>
nn <leader>gd :CrystalDef<cr>

" Testing
nn <leader>gt :CrystalSpecRunAll<cr>
