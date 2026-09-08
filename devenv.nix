{ inputs, pkgs, ... }:
let
  nixsurrealdb = inputs.nixsurrealdb.packages."${pkgs.stdenv.hostPlatform.system}";
in
{
  env.NIXPKGS_ALLOW_UNFREE = "1";
  languages.nix.enable = true;

  git-hooks.hooks = {
    # Bash
    shellcheck.enable = true;
    shfmt.enable = true;

    # Link checker
    lychee.enable = true;

    # Markdown
    markdownlint = {
      enable = true;
      settings.configuration.MD013.code_blocks = false;
    };

    # Miscellaneous
    check-added-large-files.enable = true;
    check-merge-conflicts.enable = true;
    detect-private-keys.enable = true;
    end-of-file-fixer.enable = true;
    trim-trailing-whitespace.enable = true;

    # Nix
    deadnix.enable = true;
    flake-checker.enable = true;
    nil.enable = true;
    nixfmt.enable = true;
    statix.enable = true;

    # TOML
    check-toml.enable = true;
    taplo.enable = true;

    # YAML
    check-yaml.enable = true;
    yamllint.enable = true;
  };

  packages =
    with pkgs;
    [
      git
      nixfmt
    ]
    ++ (with nixsurrealdb; [
      surrealkit
      surrealql-language-server
    ]);
}
