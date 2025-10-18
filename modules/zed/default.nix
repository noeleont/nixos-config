{ config, pkgs, lib, ... }:

{
  systemd.user.services.zed-isolated = {
    description = "Isolated Zed Editor Instance";
    wantedBy = [ ];
    
    serviceConfig = {
      ExecStart = "${pkgs.zed-editor}/bin/zed %h/workspace";
      Restart = "on-failure";
      RestartSec = "5s";
      
      # === Filesystem Isolation ===
      ProtectSystem = "strict";
      ProtectHome = "read-only";
      
      # Writable paths
      ReadWritePaths = [
        "%h/.config/zed"
        "%h/.local/share/zed"
        "%h/.zed_server"
        "%h/workspace"
        "%h/.cache/zed"
      ];
      
      # CRITICAL: Use BindReadOnlyPaths for /nix to ensure it's mounted
      # before systemd tries to exec the binary
      BindReadOnlyPaths = [
        "/nix/store"
        "/nix/var"
        "/run/current-system"  # For NixOS system dependencies
      ];
      
      # Additional read-only paths
      ReadOnlyPaths = [
        "%h/.ssh"
        "%h/.gitconfig"
        "/etc/ssl/certs"
        "/etc/static/ssl/certs"
        "${pkgs.cacert}/etc/ssl/certs"
        "/etc/resolv.conf"
        "/etc/hosts"
        "/etc/nsswitch.conf"
        "/etc/protocols"
        "/etc/services"
      ];
      
      # === Namespace Isolation ===
      PrivateTmp = true;
      PrivateDevices = true;
      
      # Don't use PrivatePID initially - can cause issues
      # PrivatePID = true;
      # PrivateIPC = true;
      # PrivateUTS = true;
      
      ProtectProc = "invisible";
      ProcSubset = "pid";
      
      # === Kernel Protection ===
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectKernelLogs = true;
      ProtectControlGroups = true;
      
      # === System Calls ===
      LockPersonality = true;
      NoNewPrivileges = true;
      RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" ];
      
      SystemCallFilter = [
        "@system-service"
        "~@privileged"
        "~@resources"
        "~@mount"
      ];
      SystemCallErrorNumber = "EPERM";
      
      RestrictNamespaces = true;
      RestrictRealtime = true;
      
      # === Capabilities ===
      CapabilityBoundingSet = [ "" ];
      AmbientCapabilities = [ "" ];
      
      # === Networking ===
      PrivateNetwork = false;
      
      # === Miscellaneous Security ===
      ProtectHostname = true;
      ProtectClock = true;
      RemoveIPC = true;
      MemoryDenyWriteExecute = false;  # Zed uses JIT
      RestrictSUIDSGID = true;
      UMask = "0077";
      
      # === Environment ===
      Environment = [
        "WAYLAND_DISPLAY=wayland-0"
        "XDG_RUNTIME_DIR=%t"
      ];
    };
  };
  
  # Helper commands
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "zed-isolated" ''
      systemctl --user start zed-isolated.service
      sleep 1
      systemctl --user is-active zed-isolated.service || {
        echo "Failed to start. Checking logs:"
        journalctl --user -u zed-isolated.service -n 20
      }
    '')
    
    (pkgs.writeShellScriptBin "zed-isolated-stop" ''
      systemctl --user stop zed-isolated.service
    '')
    
    (pkgs.writeShellScriptBin "zed-isolated-logs" ''
      journalctl --user -u zed-isolated.service -f
    '')
  ];
}
