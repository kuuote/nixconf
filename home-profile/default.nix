[
  # keep-sorted start
  "github"
  "latitude"
  "minimal"
  "sakura"
  # keep-sorted end
]
|> map (name: {
  inherit name;
  value = import ./${name}.nix;
})
|> builtins.listToAttrs
