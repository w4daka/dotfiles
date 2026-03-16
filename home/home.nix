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

    # cli
    ripgrep
    fd
    jq
    yazi
    lazygit
    ghq
    commitizen
    age

    # dev
    git
    neovim
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
    opencode
    tree-sitter
    python315

    # runtime
    nodejs_25
    deno
    pnpm_9
    go

    #markdown
    markdown-toc
    markdownlint-cli2

  ];

  programs.home-manager.enable = true;
}
