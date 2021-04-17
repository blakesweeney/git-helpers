{ pkgs ? import <nixpkgs> }: pkgs.mkShell {
  buildInputs = with pkgs; [
    datamash
    findutils
    fzf
    git
  ];
}
