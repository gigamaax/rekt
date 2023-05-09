{
  description = "rekt development environment";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        {
          devShell = pkgs.mkShell {
            name = "rekt";
            buildInputs = with pkgs; [
              just
              watchexec
            ];
          };
        }
      );
}
