with import <nixpkgs> {};

let
  isAllowed = path: type: with lib; let
    relative = removePrefix "/" (removePrefix (toString ./.) (toString path));
    splitted = splitString "/" relative;
    comp1 = head splitted;
    allowed = comp1 == "example" || comp1 == "hase" || comp1 == "test.hxml";
  in splitted != [] && allowed;

in stdenv.mkDerivation {
  name = "hase-example";
  src = builtins.filterSource isAllowed ./.;
  buildInputs = [ haxe hxcpp neko ];

  buildPhase = ''
    (cd example && haxe example.hxml)
  '';

  doCheck = true;
  checkPhase = ''
    haxe --macro 'hase.test.Main.main()'
    haxe -main hase.test.Main -cpp test -D HXCPP_M64
    ./test/Main
  '';

  installPhase = ''
    install -vD example/build/Example "$out/bin/hase-example"
    install -m 0644 -vD example/example.js "$out/share/hase/example.js"
    install -m 0644 -vD example/example.html "$out/share/hase/example.html"
  '';
}
