{
  pkgs,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    nodejs
    pnpm
  ];
  xdg.configFile."pnpm/rc".text =
    {
      resolution-mode = "time-based";
    }
    |> lib.attrsToList
    |> map (e: "${e.name}=${e.value}")
    |> builtins.concatStringsSep "\n";
}
