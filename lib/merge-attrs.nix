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
  mergeAttrs =
    attrs:
    let
      inherit (builtins) all;
      # ignore drv
      isAttrs' = e: builtins.isAttrs e && !(e ? "outPath");
    in
    builtins.zipAttrsWith (
      _: values:
      if all isAttrs' values then
        mergeAttrs values
      else if all builtins.isList values then
        builtins.concatLists values
      else if all builtins.isString values then
        builtins.concatStringsSep "" values
      else
        builtins.elemAt values ((builtins.length values) - 1)
    ) attrs;
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
