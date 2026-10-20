{ pkgs, username, ... }:

{
  # Layer 1 (APFS /nix volume, nixbld users, initial shell hooks) stays with
  # the NixOS installer; nix-darwin owns the Nix package, nix.conf and daemon.
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ username ]; # root comes from nix-darwin's default
    always-allow-substitutes = true;
  };

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
