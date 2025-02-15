{
  pkgs,
  ...
}:
{
  home.packages = [ pkgs.deno ];
  home.sessionVariables.DENO_NO_UPDATE_CHECK = "true";
}
