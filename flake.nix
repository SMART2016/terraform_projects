{
  # This is just a human-readable description of what this flake does
  description = "Terraform development environment";

  # 'inputs' specify external dependencies this flake needs
  inputs = {
    # This pulls in the Nix package collection from GitHub
    # nixos/nixpkgs is the main repository
    # nixos-unstable is the branch we're using (latest stable versions)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # flake-utils provides helper functions to make flakes work on different systems
    # (like Linux, MacOS, etc.)
    flake-utils.url = "github:numtide/flake-utils";
  };

  # 'outputs' defines what this flake produces
  # The parameters (self, nixpkgs, flake-utils) come from our inputs above
  outputs = { self, nixpkgs, flake-utils }:
    #eachSystem is a function provided by flake-utils that iterates over a predefined list of system architectures.
   # flake-utils.lib.eachSystem [ nixpkgs.lib.systems.${builtins.system} ] (



    # This creates the same environment for each supported system (Linux, MacOS, etc.)
    # eachDefaultSystem is a function provided by flake-utils that iterates over a predefined list of system architectures.
    # This list typically includes architectures like:
          #x86_64-linux (64-bit Linux)
          #aarch64-linux (64-bit ARM Linux)
          #aarch64-darwin (macOS on ARM)
          #x86_64-darwin (macOS on Intel)
    flake-utils.lib.eachDefaultSystem (

    # The Parameter (system: ...)
    # eachDefaultSystem and eachSystem both takes a function as an argument, which operates on each system architecture in its default list
    # in case of eachDefaultSystem or provided list in case of eachSystem.
    # In the expression (system: ...), the system parameter represents one of these architectures during each iteration. For example:
        # On the first iteration, system might be "x86_64-linux".
        # On the second iteration, system might be "aarch64-linux", and so on.
    system:
      #starts a block where you define local variables
      let
        # This imports the Nix packages for our current system
        #The nixpkgs identifier here refers to the path or channel
        # for the Nix package collection (e.g., GitHub's NixOS/nixpkgs repository or a local clone of it).
        pkgs = import nixpkgs { #creates a variable named pkgs that contains all the Nix packages
          # 'inherit system' : This ensures that the pkgs variable is tailored for the current system's architecture and platform.
                  # inherit:  is shorthand for "use the value of system from the surrounding scope."
                  # system typically refers to the system architecture for which the packages are being built or used, such as:
                           # x86_64-linux (64-bit Linux)
                           # aarch64-darwin (64-bit macOS on ARM)
          inherit system;
          # This configuration allows us to use packages with non-free licenses
          config = {
            allowUnfree = true;
          };
        };
      #marks the end of variable definitions and the start of where you want to use these variables
      in
      {
        # This creates a development shell environment
        # Here, pkgs is used to call the mkShell function.
        # mkShell is a utility provided by the Nix package set (nixpkgs) for creating a development shell environment.
        # It allows you to define a custom shell with specific packages installed and available.
        #The pkgs variable ensures that you're using the mkShell function from the nixpkgs repository that was previously imported
        devShell = pkgs.mkShell {
          # These are the packages that will be available in our shell
          packages = with pkgs; [
            # The terraform and terraform-ls packages are retrieved from the pkgs package set defined earlier.
            terraform      # The main Terraform package
            terraform-ls   # Terraform language server for IDE support
            graphviz       # Graphviz for visualizing Terraform graphs
            python3        # Python 3 runtime
            python3Packages.pip  # Ensure pip is available
          ];

          # Install blast-radius using yarn
          shellHook = ''
            if ! python3 -m pip show blastradius > /dev/null; then
               echo "Installing blast-radius via pip..."
               python3 -m pip install blastradius
            fi
            echo "You can now run blast-radius in this shell."
          '';
        };
      });
}