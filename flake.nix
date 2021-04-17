{
  description = "A flake for some git tools I have created";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
          rec {
            defaultPackage =
              pkgs.eggDerivation rec {
                name = "git-helpers";
                version = "v1.0";
                src = self;

                buildInputs = with pkgs; [
                  bash
                  coreutils
                  datamash
                  fzf
                  git
                  makeWrapper
                ];

                installPhase = with pkgs; ''
                  mkdir -p $out
                  cp -a bin $out

                  wrapProgram $out/bin/git-branch-name \
                    --prefix PATH : ${lib.makeBinPath [ bash git ]}

                  wrapProgram $out/bin/git-open \
                    --prefix PATH : ${lib.makeBinPath [ bash git ]}

                  wrapProgram $out/bin/cig \
                    --prefix PATH : ${lib.makeBinPath [ bash git datamash coreutils ]}

                  wrapProgram $out/bin/git-pick \
                    --prefix PATH : ${lib.makeBinPath [ bash git fzf ]}

                  wrapProgram $out/bin/git-prune-merged \
                    --prefix PATH : ${lib.makeBinPath [ bash coreutils git fzf ]}

                  wrapProgram $out/bin/git-prune-merged \
                    --prefix PATH : ${lib.makeBinPath [ bash coreutils git ]}
                '';

                meta = with pkgs.lib; {
                  homepage = https://github.com/blakesweeney/git-helpers/releases;
                  description = "A small set of git utilities";
                  licenses = licenses.mit;
                  platforms = platforms.all;
                };
              };
          }
    );
}
