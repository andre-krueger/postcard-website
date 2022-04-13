{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=21.11";
    nixos-shell = {
      url = "github:Mic92/nixos-shell?ref=1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    crane = {
      url = "github:ipetkov/crane?ref=v0.3.3";
      inputs.nixkpgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixkpgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, rust-overlay, crane, nixos-shell, ... }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        overlays = [ rust-overlay.overlay ];
      };

      checkNixFilesFormatting = pkgs.stdenv.mkDerivation {
        name = "checkNixFilesFormatting";
        src = ./.;
        installPhase = ''
          find . -type f -name '*.nix' ! -name 'yarn-project.nix' | xargs nixfmt -c
          mkdir $out
        '';
        buildInputs = [ pkgs.nixfmt ];
      };

      rust = pkgs.rust-bin.stable.latest.default;

      backendSrc = ./backend;

      craneLib = (crane.lib.${system}).overrideScope' (final: prev: {
        rustc = rust;
        cargo = rust;
        rustfmt = rust;
        clippy = rust;
      });

      cargoArtifacts = craneLib.buildDepsOnly { src = backendSrc; };

      frontend = pkgs.callPackage ./frontend { };

      backendPreBuildPhase = ''
        mkdir -p static
        cp -r ${frontend}/static/* static
      '';

      backendCheck = craneLib.cargoClippy {
        inherit cargoArtifacts;
        src = backendSrc;
        preBuild = backendPreBuildPhase;
        cargoClippyExtraArgs = "--all-features -- -D warnings";
      };

      backendFormat = craneLib.cargoFmt { src = backendSrc; };

      backend = craneLib.buildPackage {
        cargoArtifacts = backendCheck;
        src = backendSrc;
        preBuild = backendPreBuildPhase;
      };
    in {
      devShells.${system}.default =
        pkgs.mkShell { buildInputs = [ nixos-shell ]; };

      checks.${system} = {
        inherit checkNixFilesFormatting frontend backendCheck backendFormat;
      };

      nixosConfigurations = let lib = nixpkgs.lib;
      in {
        vm = lib.makeOverridable lib.nixosSystem {
          system = system;
          specialArgs = { inherit frontend backend; };
          modules =
            [ nixos-shell.nixosModules.nixos-shell ./common.nix ./vm.nix ];
        };
      };
    };
}
