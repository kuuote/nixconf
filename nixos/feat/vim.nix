{
  inputs,
  pkgs,
}:
let
  # Neovimの先っちょが要求するのでとりあえず
  utf8proc-latest = pkgs.utf8proc.overrideAttrs {
    version = "latest";
    src = pkgs.fetchFromGitHub {
      owner = "JuliaStrings";
      repo = "utf8proc";
      rev = "3de4596fbe28956855df2ecb3c11c0bbc3535838";
      sha256 = "sha256-DNnrKLwks3hP83K56Yjh9P3cVbivzssblKIx4M/RKqw=";
    };
  };
in
{
  environment = {
    # Vimは先っちょをビルドしたい
    systemPackages = [
      # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      # vim
      (pkgs.vim.overrideAttrs (oldAttrs: {
        version = "latest";
        src = inputs.vim-src;
        buildInputs = oldAttrs.buildInputs ++ [ pkgs.lua ];
        configureFlags = oldAttrs.configureFlags ++ [
          "--enable-luainterp"
          "--with-lua-prefix=${pkgs.lua}"
          "--enable-fail-if-missing"
        ];
      }))
      # neovim
      (pkgs.neovim-unwrapped.overrideAttrs (oldAttrs: {
        version = "latest";
        src = inputs.neovim-src;
        buildInputs = oldAttrs.buildInputs ++ [ utf8proc-latest ];
        # installPhaseでもビルド走るのでbuildPhaseを潰す
        buildPhase = "true";
      }))
    ];
    variables = {
      # Vimは真理
      EDITOR = "vim";
      VISUAL = "vim";
    };
  };
}
