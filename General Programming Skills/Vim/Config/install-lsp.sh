#!/bin/bash
echo "Installing LSP servers with Mason..."
nvim --headless -c "MasonInstall pyright bashls lua_ls ts_ls html cssls clangd gopls rust-analyzer ruby-lsp jsonls yamlls terraform-ls jdtls" -c "qa"
echo "LSP servers installed!"
