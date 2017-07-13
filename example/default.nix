{ pkgs ? import <nixpkgs> {}, target ? "js", hxArgs ? [] }:

let
  inherit (pkgs) lib;

  hase = import ../. {
    inherit pkgs;
    runTests = false;
  };

  isAllowed = path: type: with lib; let
    relative = removePrefix "/" (removePrefix (toString ./.) (toString path));
    splitted = splitString "/" relative;
    comp1 = head splitted;
    allowed = elem comp1 [ "example.html" "Example.hx" "gfx" ];
  in splitted != [] && allowed;

in pkgs.stdenv.mkDerivation (rec {
  name = "hase-example-${version}";
  inherit (hase) version;

  src = builtins.filterSource isAllowed ./.;

  buildInputs = [ pkgs.haxe hase ]
             ++ lib.optional (target == "cpp") pkgs.hxcpp;

  inherit target hxArgs;

  targetPath = "example.${if target == "neko" then "n" else target}";
  installBinary = targetPath;
  installPath = "/share/hase-example";
  installMode = "0644";

  buildPhase = ''
    haxe -main Example -lib hase \
      "-$target" "$targetPath" \
      -dce full $targetFlags $hxArgs
  '';

  installPhase = ''
    install -vD -m "$installMode" "$installBinary" \
      "$out$installPath/$targetPath"
  '' + lib.optionalString (target == "js") ''
    install -m 0644 -vD example.html "$out$installPath/example.html"
  '';
} // lib.optionalAttrs (target == "cpp") {
  targetPath = "hase-example";
  installBinary = "hase-example/Example";
  installPath = "/bin";
  installMode = "0755";
})
