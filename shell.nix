{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    name = "otus-dev";
    buildInputs = [
      pkgs.ansible_2_10
      pkgs.ansible-lint
      pkgs.terraform_0_12
      pkgs.tflint
      pkgs.packer
      pkgs.vagrant
    ];
    shellHook = ''
      echo "Go hacking..."
    '';
}
