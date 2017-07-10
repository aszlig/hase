{ pkgs ? import <nixpkgs> {}, buildExample ? true, runTests ? true }:

let
  inherit (pkgs) lib;

  isAllowed = path: type: with lib; let
    relative = removePrefix "/" (removePrefix (toString ./.) (toString path));
    splitted = splitString "/" relative;
    comp1 = head splitted;
    allowed = comp1 == "example" || comp1 == "hase" || comp1 == "test.hxml";
  in splitted != [] && allowed;

  forEachTest = fun: let
    preloaders = map toString (lib.range 1 3);

    mkPreloadMain = p: "hase.test.preloader.PreloaderTest${p}";
    preloadMains = map mkPreloadMain preloaders;
    mains = lib.singleton "hase.test.Main" ++ preloadMains;

    preloadTargets = map (p: "preload_test_${p}") preloaders;
    targets = lib.singleton "main_tests" ++ preloadTargets;

  in lib.concatStringsSep "\n" (lib.zipListsWith fun mains targets);

  compileWith = targetLang: main: target: let
    file = if targetLang == "cpp" then target
           else if targetLang == "neko" then "${target}.n"
           else "${target}.${targetLang}";
    args = [ "haxe" "-main" main "-${targetLang}" file "-dce" "full" ];
  in lib.concatMapStringsSep " " lib.escapeShellArg args;

in pkgs.stdenv.mkDerivation rec {
  name = "hase";
  version = "0.1.0";
  src = builtins.filterSource isAllowed ./.;

  nativeBuildInputs = [ pkgs.phantomjs ];
  buildInputs = [ pkgs.haxe pkgs.hxcpp pkgs.neko ];

  outputs = lib.singleton "out" ++ lib.optional buildExample "example";

  buildPhase = lib.optionalString runTests ''
    ${forEachTest (compileWith "neko")}
    ${forEachTest (compileWith "js")}
    ${forEachTest (compileWith "cpp")}
  '' + lib.optionalString buildExample ''
    (cd example && haxe example.hxml)
  '';

  doCheck = runTests;

  checkPhase = ''
    header "running C++ tests"
    ${forEachTest (main: target: let
      mainCls = lib.head (builtins.match ".*\\.(.+)" main);
    in "./${target}/${mainCls}")}
    stopNest
    header "running Neko tests"
    ${forEachTest (main: target: "neko ${target}.n")}
    stopNest
    header "running JS tests"
    ${forEachTest (main: target: "phantomjs ${target}.js")}
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
