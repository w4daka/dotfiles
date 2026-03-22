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

    # runtime
    nodejs_25
    deno
    pnpm_9
    go
    python315

    #markdown
    markdown-toc
    markdownlint-cli2

  ];

  programs.home-manager.enable = true;
}
