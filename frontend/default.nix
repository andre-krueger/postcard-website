{ pkgs }:

let project = pkgs.callPackage ./yarn-project.nix { } { src = ./.; };

in project.overrideAttrs (oldAttrs: {
  buildInputs = oldAttrs.buildInputs ++ [ pkgs.python3 ];
  buildPhase = ''
    yarn prettier .postcssrc .parcelrc .. --check
    yarn tsc --noEmit
    yarn eslint .
    yarn build
    mkdir -p $out/static
    cp -r dist/* $out/static
  '';
})
