{ pkgs, username, ... }:

{
  # Layer 1 (APFS /nix volume, nixbld users, initial shell hooks) stays with
  # the NixOS installer; nix-darwin owns the Nix package, nix.conf and daemon.
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ username ]; # root comes from nix-darwin's default
    always-allow-substitutes = true;
  };

  # Private root CA for .dim (name-constrained to .dim, no IPs).
  # Appended to nix-darwin's bundle at /etc/ssl/certs/ca-certificates.crt
  # (NIX_SSL_CERT_FILE); the module's default cacert bundle stays in the list.
  security.pki.certificateFiles = [ ./pki/dim-ca-root-v1.crt ];

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
