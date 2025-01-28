{
  cmake,
  gettext,
  lib,
  linkFarm,
  neovim-src,
  stdenv,
}:
let
  deps = lib.pipe "${neovim-src}/cmake.deps/deps.txt" [
    builtins.readFile
    (builtins.split "[\n]")
    (builtins.filter builtins.isString)
    (builtins.map (builtins.match "([0-9A-Z_]+)_(URL|SHA256) (.+)"))
    (builtins.filter builtins.isList)
    (builtins.map (m: {
      "${lib.toLower (builtins.elemAt m 0)}" = {
        "${lib.toLower (builtins.elemAt m 1)}" = builtins.elemAt m 2;
      };
    }))
    (builtins.foldl' lib.recursiveUpdate { })
    (lib.mapAttrs' (
      name: value: {
        name = "${name}/${builtins.baseNameOf value.url}";
        value = builtins.fetchurl value;
      }
    ))
    (linkFarm "deps")
  ];
in
stdenv.mkDerivation {
  name = "neovim";
  src = neovim-src;
  buildInputs = [
    cmake
    gettext
  ];
  patchPhase = ''
    mkdir -p .deps/build
    cp -a ${deps} .deps/build/downloads
    make -j$NIX_BUILD_CORES deps
  '';
  # installPhaseでもビルド走るのでbuildPhaseを潰す
  buildPhase = "true";
}
