[
  # keep-sorted start
  "github"
  "latitude"
  "sakura"
  # keep-sorted end
]
|> map (name: {
  inherit name;
  value = import ./${name}.nix;
})
|> builtins.listToAttrs
