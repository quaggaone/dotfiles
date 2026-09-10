{
  description = "felixdim's darwin substrate";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, sops-nix, ... }:
    let
      hostname = "FD-MAC-03M4";
      username = "felixdim";
      system = "aarch64-darwin";
    in
    {
      # nix run .#obsidian-connector-health
      packages.${system}.obsidian-connector-health =
        import ./nix/claude/obsidian-health.nix {
          pkgs = nixpkgs.legacyPackages.${system};
          cert = ./nix/obsidian/local-api-ca.pem;
          url = "https://127.0.0.1:27124/mcp/";
          tokenPath = "/Users/${username}/.config/sops-nix/secrets/obsidian-local-api-key";
        };

      # Keyed by hostname: darwin-rebuild resolves the attribute from the
      # machine's name, so this must match `scutil --get LocalHostName`.
      # The config itself is host-agnostic; identity is passed via specialArgs.
      darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = { inherit hostname username; };
        modules = [
          ./nix/darwin.nix
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit hostname username; };
              users.${username} = import ./nix/home.nix;
              sharedModules = [ sops-nix.homeManagerModules.sops ];
            };
          }
        ];
      };
    };
}
