{
  description = "Haxe Ascii Spriting Engine";

  outputs = { self, nixpkgs }: let
    inherit (nixpkgs) lib;
    systems = lib.attrNames (removeAttrs nixpkgs.legacyPackages [
      # Excluding architectures where OCaml is either broken or unsupported.
      "aarch64-linux" "armv6l-linux" "armv7l-linux"
    ]);
    forAllSystems = lib.genAttrs systems;

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

    mkPackage = runTests: isShell: system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in pkgs.stdenv.mkDerivation rec {
      pname = "hase";
      version = "0.1.0";
      src = if isShell then null else self;

      nativeBuildInputs = [ pkgs.phantomjs ];
      buildInputs = [ pkgs.haxe pkgs.hxcpp pkgs.neko ];

      buildPhase = lib.optionalString runTests ''
        ${forEachTest (compileWith "neko")}
        ${forEachTest (compileWith "js")}
        ${forEachTest (compileWith "cpp")}
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
      };
    };

  in {
    packages = forAllSystems (system: {
      hase = mkPackage false false system;
    });

    defaultPackage = forAllSystems (system: self.packages.${system}.hase);
    checks = forAllSystems (system: {
      unit = mkPackage true false system;
    });
    devShell = forAllSystems (mkPackage false true);
  };
}
