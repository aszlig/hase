{ pkgs ? import <nixpkgs> {}, buildExample ? true, runTests ? true }:

let
  inherit (pkgs) lib;

  isAllowed = path: type: with lib; let
    relative = removePrefix "/" (removePrefix (toString ./.) (toString path));
    splitted = splitString "/" relative;
    comp1 = head splitted;
    allowed = comp1 == "example" || comp1 == "hase" || comp1 == "test.hxml";
  in splitted != [] && allowed;

in pkgs.stdenv.mkDerivation rec {
  name = "hase";
  version = "0.1.0";
  src = builtins.filterSource isAllowed ./.;

  nativeBuildInputs = [ pkgs.phantomjs ];
  buildInputs = [ pkgs.haxe pkgs.hxcpp pkgs.neko ];

  outputs = lib.singleton "out" ++ lib.optional buildExample "example";

  buildPhase = lib.optionalString buildExample ''
    (cd example && haxe example.hxml)
  '' + lib.optionalString runTests ''
    haxe -main hase.test.Main -cpp test -D HXCPP_M64 -dce full
    haxe -main hase.test.Main -js test.js -dce full
  '';

  doCheck = runTests;

  checkPhase = ''
    header "running C++ tests"
    ./test/Main
    stopNest
    header "running Neko tests"
    haxe --macro 'hase.test.Main.main()'
    stopNest
    header "running JS tests"
    phantomjs test.js
    stopNest
  '';

  installPhase = pkgs.haxePackages.installLibHaxe {
    libname = "hase";
    inherit version;
    files = "hase";
  } + lib.optionalString buildExample ''
    install -vD example/build/Example "$example/bin/example"
    install -vD example/example.n "$example/libexec/hase/example.n"
    install -m 0644 -vD example/example.js "$example/share/hase/example.js"
    install -m 0644 -vD example/example.html "$example/share/hase/example.html"
  '';
}
