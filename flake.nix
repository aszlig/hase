{
  description = "Haxe Ascii Spriting Engine";

  outputs = { self, nixpkgs }: let
    inherit (nixpkgs) lib;
    version = "0.1.0";

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

    mkPackage = pkgs: runTests: isShell: pkgs.stdenv.mkDerivation {
      pname = "hase";
      inherit version;
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

    mkPackageWithSystem = system: mkPackage nixpkgs.legacyPackages.${system};

    mkExample = system: target: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ self.overlay ];
      };
    in pkgs.buildHaseApplication ({
      mainClass = "Example";
      pname = "hase-example";
      inherit version target;
      src = ./example;

      postInstall = ''
        if [ "$target" = js ]; then
          install -m 0644 -vD example.html "$installPath/example.html"
        fi
      '';
    } // lib.optionalAttrs (target == "cpp") {
      executableName = "hase-example";
    });

  in {
    packages = forAllSystems (system: {
      hase = mkPackageWithSystem system false false;

      example-js = mkExample system "js";
      example-neko = mkExample system "neko";
      example-cpp = mkExample system "cpp";
    });

    overlay = final: prev: {
      haxePackages = prev.haxePackages // {
        hase = mkPackage prev false false;
      };

      buildHaseApplication =
        { mainClass
        , executableName ? lib.toLower mainClass
        , pname ? executableName
        , target ? "js"
        , hxArgs ? []
        , ...
        }@attrs:
      let
        programSuffix = if target == "neko" then "n" else target;

        drvAttrs = rec {
          buildInputs = [ final.haxe final.haxePackages.hase ]
                     ++ lib.optional (target == "cpp") final.hxcpp
                     ++ (attrs.buildInputs or []);

          inherit pname mainClass target hxArgs;

          targetPath = "${executableName}.${programSuffix}";
          installBinary = targetPath;
          installPath = "${placeholder "out"}/share/${pname}";
          installMode = "0644";

          buildPhase = ''
            runHook preBuild

            haxe -main "$mainClass" -lib hase "-$target" "$targetPath" \
              -dce full $hxArgs

            runHook postBuild
          '';

          installPhase = ''
            runHook preInstall

            install -vD -m "$installMode" "$installBinary" \
              "$installPath/$targetPath"

            runHook postInstall
          '';
        } // lib.optionalAttrs (target == "cpp") {
          targetPath = executableName;
          installBinary = "${executableName}/${mainClass}";
          installPath = "${placeholder "out"}/bin";
          installMode = "0755";
        };

        finalAttrs = drvAttrs // removeAttrs attrs [ "buildInputs" ];

      in final.stdenv.mkDerivation finalAttrs;
    };

    defaultPackage = forAllSystems (system: self.packages.${system}.hase);
    checks = forAllSystems (system: {
      unit = mkPackageWithSystem system true false;
    });
    devShell = forAllSystems (system: mkPackageWithSystem system false true);
  };
}
