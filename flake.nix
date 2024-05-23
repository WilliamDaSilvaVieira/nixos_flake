{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Nixpkgs-f2k
    nixpkgs-f2k.url = "github:moni-dz/nixpkgs-f2k";
  };
  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, ... }@inputs:
    let
      inherit (self) outputs;
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      lib = nixpkgs.lib;
    in {
      overlays = import ./overlays { inherit inputs; };
      nixosConfigurations = {
        william = lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          inherit system;
          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.william = {
                imports = [ ./home.nix ];
              };
            }
          ];
        };
      };
    };

}
