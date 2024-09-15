{
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "xremap";
  version = "v0.10.0";
  src = fetchFromGitHub {
    owner = "xremap";
    repo = "xremap";
    rev = version;
    hash = "sha256-TZvi5EOZ5Ekg8aGXCAzCcphJ7U5YsPtTWKTUQKZXEsg=";
  };
  cargoHash = "sha256-2a66jPpb/fdI4EBMUgYW3NTlQGKlsOAUYvZendHK9+o=";
}
