[
  # keep-sorted start
  "latitude"
  "sakura"
  # keep-sorted end
]
|> map (name: {
  inherit name;
  value = import ./${name}.nix;
})
|> builtins.listToAttrs
