 {
   description = "Terraform development environment";

   inputs = {
     nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
     flake-utils.url = "github:numtide/flake-utils";
   };

   outputs = { self, nixpkgs, flake-utils }:
     flake-utils.lib.eachDefaultSystem (system:
       let
         pkgs = nixpkgs.legacyPackages.${system};
       in
       {
         devShell = pkgs.mkShell {
           packages = with pkgs; [
             terraform
             terraform-ls
           ];

           shellHook = ''
             echo "Terraform development environment loaded"
             echo "Terraform version: $(terraform version)"
           '';
         };
       });
 }