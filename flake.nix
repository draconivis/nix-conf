{
  description = "draconivis' nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations = {
      # work laptop
      p14s = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [ ./hosts/p14s ];
      };
      # private laptop
      t590 = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [ ./hosts/t590 ];
      };
    };
    homeConfigurations = {
      "patrick@p14s" = nixpkgs.lib.homeManagerConfiguration {
        extraSpecialArgs = {inherit inputs;};
        modules = [
          ./home/patrick/p14s.nix
        ];
      };
      "patrick@t590" = nixpkgs.lib.homeManagerConfiguration {
        extraSpecialArgs = {inherit inputs;};
        modules = [
          ./hosts/work/work.nix
        ];
      };
    };
  };
}
