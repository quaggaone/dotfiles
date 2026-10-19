{ username, ... }:

{
  imports = [ ./claude ];

  home.username = username;
  home.homeDirectory = "/Users/${username}";

  programs.git.enable = true;

  sops = {
    age.keyFile = "/Users/${username}/.config/sops/age/keys.txt";
    secrets.obsidian-local-api-key = {
      sopsFile = ./secrets/obsidian.yaml;
      key = "api-key";
    };
  };

  home.stateVersion = "26.05";
}
