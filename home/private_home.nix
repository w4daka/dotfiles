{ config, pkgs, ... }:

{
  home.username = "w4dkaka";
  home.homeDirectory = "/home/w4dkaka";

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
    yazi
    lazygit
    ghq
    commitizen
    age
    pandoc
    lazydocker
    codex
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
    nodejs_25
    deno
    yarn
    pnpm_9
    go
    python315

    #markdown
    markdown-toc
    markdownlint-cli2

  ];

  programs.home-manager.enable = true;
}
