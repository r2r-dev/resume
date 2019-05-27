{pkgs ? import <nixpkgs> {} }:
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
