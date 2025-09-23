{ pkgs, ... }:

{

  imports = [
          ../../modules/home.nix
  ];

  home.username = "noeleon";
  home.homeDirectory = "/home/noeleon";

  home.shellAliases = {
    grep = "grep --color";
    tf = "tofu";
    k = "kubectl";
    la = "exa -hal";

    ".." = "cd ..";
    "..." = "cd ../..";
  };

  home.packages = with pkgs; [
    # archives
    zip
    xz
    unzip
    p7zip

    # utils
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processor https://github.com/mikefarah/yq
    eza # A modern replacement for ‘ls’
    fzf # A command-line fuzzy finder

    # networking tools
    mtr # A network diagnostic tool
    iperf3
    dnsutils # `dig` + `nslookup`
    ldns # replacement of `dig`, it provide the command `drill`
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing
    ipcalc # it is a calculator for the IPv4/v6 addresses

    # misc
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg
    thefuck

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor
    nixd

    # productivity
    glow # markdown previewer in terminal
    dive
    delta
    ghostty
    gnumake
    firefox
    chromium
    zellij
    go

    btop # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring

    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files

    # system tools
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb

    # k8s
    kubectl
    clusterctl
    kubernetes-helm-wrapped

    # terraform
    opentofu
  ];

  programs.git = {
    enable = true;
    userName = "Noe Thalheim";
    userEmail = "noe@thalheim.email";
    extraConfig = {
      core = {
        pager = "delta --line-numbers --dark --side-by-side";
        editor = "vim";
        whitespace = "fix,-indent-with-non-tab,trailing-space,cr-at-eol";
      };
      format = {
        pretty = "%C(blue)%h%Creset %s %C(green)%d%Creset [%C(red)%an%Creset, %C(cyan)%cr%Creset] %C(bold reverse)%N%Creset";
      };
      branch = {
        autosetuprebase = "always";
      };
    };
  };

  programs.chromium = {
    enable = true;
    extensions = [
      "ddkjiahejlhfcafbddmgiahcphecmpfh"
    ];
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };
}
