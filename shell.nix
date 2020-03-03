{ pkgs ? import (builtins.fetchTarball {
  name = "nixos-unstable-2019-12-05";
  url =  https://github.com/nixos/nixpkgs/archive/cc6cf0a96a627e678ffc996a8f9d1416200d6c81.tar.gz;
  sha256 = "1srjikizp8ip4h42x7kr4qf00lxcp1l8zp6h0r1ddfdyw8gv9001";
}) {} }:

let
  pkg = pkgs.emacsPackagesNgGen pkgs.emacs;
  emacs = pkg.emacsWithPackages (epkgs: [ epkgs.htmlize ]);
in pkgs.stdenv.mkDerivation {
  name = "deals-entrypoint";
  buildInputs = with pkgs; [ emacs bash wkhtmltopdf busybox ];
  shellHook = ''
    mv resume.pdf resume.pdf.bak
    mv index.html index.html.bak
    emacs -Q --script ${./org-export.el} -f export-index-to-html;
    wkhtmltopdf index.html resume.pdf
  '';
}
