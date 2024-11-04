{
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "xremap";
  version = "v0.10.2";
  src = fetchFromGitHub {
    owner = "xremap";
    repo = "xremap";
    rev = version;
    hash = "sha256-UMcyT3CradQsshYTnqUrkrusF+7aUcxHQQm7DGhHEVg=";
  };
  cargoHash = "sha256-IIqClLxOUJN4jax3Y9h8wfr+zI4kHGyFcFBiWvLPQOY=";
}
