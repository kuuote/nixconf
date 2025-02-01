{
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "xremap";
  version = "v0.10.4";
  src = fetchFromGitHub {
    owner = "xremap";
    repo = "xremap";
    rev = version;
    hash = "sha256-71Uz2jdiMv5BsEYCqKpueQZrfcdga0wZIxoNKqZyYEo=";
  };
  cargoLock = {
    lockFile = "${src}/Cargo.lock";
  };
}
