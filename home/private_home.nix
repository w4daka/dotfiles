{ config, pkgs, ... }:

{
  home.username = "w4daka";
  home.homeDirectory = "/home/w4daka";

  home.stateVersion = "25.05";

  home.packages = with pkgs; [

    # shell
    starship
    zoxide
    fzf
    sheldon

    # cli
    ripgrep
    fd
    jq
    lazygit
    ghq
    lazydocker
    devcontainer
    eza
    vim-startuptime

    # dev
    git
    nixd
    nixfmt
    bat
    direnv
    nix-direnv
    gh
    llama-cpp
    repomix
    uv
    tree-sitter
    clang-tools

    # lua
    lua-language-server
    stylua
    luaPackages.luacheck

    # runtime
    deno
    go

    #markdown
    markdownlint-cli2

    # formatter
    prettierd

  ];

  programs.home-manager.enable = true;
}
