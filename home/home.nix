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

    # dev
    git
    neovim
    nixd
    nixfmt
    zellij
    bat
    direnv
    nix-direnv
    gh

    # runtime
    nodejs_25
    deno
    pnpm_9
    go
  ];

  programs.home-manager.enable = true;
}
