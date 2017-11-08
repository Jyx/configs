#!/usr/bin/env bash

# Solarized
git clone git://github.com/altercation/vim-colors-solarized.git


# Fugitive
git clone https://github.com/tpope/vim-fugitive.git
vim -u NONE -c "helptags vim-fugitive/doc" -c q

# Unimpaired
git clone git://github.com/tpope/vim-unimpaired.git
vim -u NONE -c "helptags vim-unimpaired/doc" -c q

# Vimwiki
git clone https://github.com/vimwiki/vimwiki.git
vim -u NONE -c "helptags" -c q

