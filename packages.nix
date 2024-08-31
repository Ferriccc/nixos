{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    wget
    curl
    neovim
    ripgrep
    gnumake
    gnome-calculator
    cargo
    powertop
    htop
    wpsoffice
    fastfetch
    pciutils
    swww
    dunst
    trash-cli
    ntfs3g
    hyprshot
    nodejs_22
    (python3.withPackages (python-pkgs: [
      python-pkgs.pynvim
      python-pkgs.pygobject3
    ]))
    clang-tools
    gcc13
    unzip
    nur.repos.nltch.spotify-adblock
    brightnessctl
    eza
    wl-clipboard
    clip
    cliphist
    waybar
    wofi
    discord
    kitty
    git
    gh
    vscode
    starship
    zoxide
    google-chrome
    firefox
  ];
}
