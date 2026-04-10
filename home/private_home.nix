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
    age
    pandoc
    lazydocker
    codex
    devcontainer
    eza

    # dev
    git
    nixd
    nixfmt
    bat
    direnv
    nix-direnv
    gh
    llama-cpp
    lua-language-server
    stylua
    repomix
    uv
    tree-sitter

    # runtime
    deno
    go

    #markdown
    markdown-toc
    markdownlint-cli2

  ];

  programs.home-manager.enable = true;
}
