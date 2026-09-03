{
  config,
  inputs,
  pkgs,
  ...
}:
let
  nixsurrealdb = inputs.nixsurrealdb.packages."${pkgs.stdenv.hostPlatform.system}";
in
{
  env.NIXPKGS_ALLOW_UNFREE = "1";

  git-hooks.hooks = {
    # Bash
    shellcheck.enable = true;
    shfmt.enable = true;

    # Link checker
    lychee.enable = true;

    # Go
    gofmt.enable = true;
    golangci-lint.enable = true;

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

    flake-checks = {
      enable = true;
      entry = ''nix flake check --impure --all-systems "${config.git.root}"'';
      pass_filenames = false;
    };

    # TOML
    check-toml.enable = true;
    taplo.enable = true;

    # YAML
    check-yaml.enable = true;
    yamllint.enable = true;
  };

  languages = {
    go.enable = true;
    nix.enable = true;
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
