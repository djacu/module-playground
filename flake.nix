{
  description = "A very basic flake";

  outputs = { self, nixpkgs }: {
    nixosConfigurations.test = nixpkgs.lib.nixosSystem {
      modules = [
        ./modules.nix
        {
          nixpkgs.hostPlatform = "x86_64-linux";
          playground.enable = true;
        }
      ];
    };

  };
}
