{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-23_11.url = "github:nixos/nixpkgs/nixos-23.11";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Nixpkgs-f2k
    nixpkgs-f2k.url = "github:moni-dz/nixpkgs-f2k";
    #Hyprland
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    #Cosmic
    # nixos-cosmic = {
    #   url = "github:lilyinstarlight/nixos-cosmic";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };
  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      nixpkgs-23_11,
      home-manager,
      # nixos-cosmic,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      lib = nixpkgs.lib;
    in
    {
      overlays = import ./overlays { inherit inputs; };
      nixosConfigurations = {
        william = lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
          };
          inherit system;
          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.william = {
                imports = [ ./home.nix ];
              };
              # nix.settings = {
              #   substituters =  ["https://cosmic.cachix.org/"];
              #   trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRe102smYzA85dPE=" ];
              # };
            }
            # nixos-cosmic.nixosModules.default
          ];
        };
      };
    };
}
