{ pkgs, username, ... }:

{
  # Nix is installed and managed by the nix-community installer, which owns
  # /etc/nix/nix.conf and the daemon. Enabling this means two things writing
  # the same file; own settings belong in /etc/nix/nix.custom.conf.
  nix.enable = false;

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };

  environment.systemPackages = with pkgs; [
    age
    sops
    ssh-to-age
  ];

  system.primaryUser = username;
  system.stateVersion = 7;
}
