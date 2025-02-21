{
  pkgs,
  inputs,
  ...
}:
let
  src = "${(import "${inputs.self.outPath}/src" { inherit pkgs; }).deno-pty-ffi}/src-rust";
in
{
  xdg.configFile = {
    "vim-nix/deno-pty-ffi".source = pkgs.rustPlatform.buildRustPackage {
      name = "deno-pty-ffi";
      inherit src;
      cargoLock = {
        lockFile = "${src}/Cargo.lock";
      };
      doCheck = false;
    };
  };
}
