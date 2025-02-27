{
  description = "Nix configuration for my machines";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nix-darwin,
    }:
    let
      systems = [
        "aarch64-darwin"
        "x86_64-linux"
      ];

      forAllSystems =
        function:
        (nixpkgs.lib.genAttrs systems (
          system:
          function (
            let
              pkgs = nixpkgs.legacyPackages.${system};
            in
            {
              inherit pkgs system;
            }
          )
        ));
    in
    {
      homeConfigurations."montaigne" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."aarch64-darwin";
        modules = [
          ./machines/montaigne/home.nix
        ];
      };

      darwinConfigurations."montaigne" = nix-darwin.lib.darwinSystem {
        modules = [
          ./machines/montaigne/configuration.nix
        ];

        specialArgs = { inherit self; };
      };

      formatter = forAllSystems ({ pkgs, ... }: pkgs.nixfmt-rfc-style);

      devShells = forAllSystems (
        { pkgs, ... }:
        {
          default = pkgs.mkShell {
            name = "machines";
            packages = with pkgs; [
              nixfmt-rfc-style
            ];
          };
        }
      );
    };
}
