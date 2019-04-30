" Run `crystal tool format` on save
"let g:crystal_auto_format = 1

" tab settings
set ts=2 sw=2 et

" General
nn <leader>b :!crystal build %<cr>
nn <leader>r :!crystal run --no-color %<cr>

" Navigation
nn <leader>gh :CrystalHierarchy<space>
nn <leader>gd :CrystalDef<cr>

" Testing
nn <leader>gt :CrystalSpecRunAll<cr>
