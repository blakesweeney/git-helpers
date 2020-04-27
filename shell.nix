let
  pkgs = import <nixpkgs> {};
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    datamash
    findutils
    fzf
    git
    pe
  ];
}
