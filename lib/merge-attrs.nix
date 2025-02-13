let
  inherit (builtins)
    attrNames
    foldl'
    isAttrs
    isFunction
    isList
    isNull
    isPath
    isString
    ;
in
rec {
  # nixpkgs's foldAttrs mimic
  # from https://github.com/NixOS/nixpkgs/blob/5fbeaf6d89ff1ff08a59a0f0b34d6eb33fb75307/lib/attrsets.nix#L817
  foldAttrs =
    op: nul: list_of_attrs:
    foldl' (
      a: n: foldl' (o: name: o // { ${name} = op (a.${name} or nul) n.${name}; }) a (attrNames n)
    ) { } list_of_attrs;
  mergeAttrs =
    attrs:
    foldAttrs (
      acc: item:
      if isAttrs item && item ? "outPath" then
        item
      else if isAttrs item && isAttrs acc then
        mergeAttrs [
          acc
          item
        ]
      else if isList item && isList acc then
        acc ++ item
      else if isNull item then
        acc
      else
        item
    ) null attrs;
  importAttrs =
    let
      maybeImport = target: if isString target || isPath target then import target else target;
      maybeEval =
        target: args:
        let
          module = maybeImport target;
        in
        if isFunction module then module args else module;
    in
    modules: args: mergeAttrs (builtins.map (target: maybeEval (maybeImport target) args) modules);
}
