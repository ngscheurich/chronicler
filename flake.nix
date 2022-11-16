{
  description = "Development environment for Chronicler";

  nixConfig.bash-prompt = "\\033[32m\[nix-develop\:$PWD]$\\033[0m ";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let pkgs = nixpkgs.legacyPackages.${system}; in
        {
          devShells.default = pkgs.mkShell {
            nativeBuildInputs = with pkgs; [
              erlangR25
              beam.packages.erlangR25.elixir_1_14
              # beam.packages.erlangR25.elixir_ls
            ];
          };
        }
      );
}
