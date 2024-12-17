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

    #Zen-Browser
    zen-browser.url = "github:ch4og/zen-browser-flake";
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
      forAllSystems = nixpkgs.lib.genAttrs [
        "aarch64-darwin"
        "aarch64-linux"
        "i686-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
      system = "x86_64-linux";
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        import ./pkgs { inherit pkgs; }
      );
      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        import ./shell.nix { inherit pkgs; }
      );
      overlays = import ./overlays { inherit inputs; };
      nixosConfigurations = {
        william = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
          };
          inherit system;
          modules = [
            ./nixos/configuration.nix
            ./home_manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
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
