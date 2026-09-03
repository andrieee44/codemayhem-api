{
  perSystem =
    { pkgs, self', ... }:
    {
      checks.university-judge = self'.packages.university-judge;
      packages.university-judge = pkgs.callPackage ./_src { };
    };
}
