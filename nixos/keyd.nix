{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.keyd ];
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = {
          main = {
            # keep-sorted start
            capslock = "overload(control, esc)"; # Aの横にあるキーはCtrlなの！！
            enter = "overload(alt, enter)";
            tab = "overload(meta, tab)";
            # keep-sorted end

            muhenkan = "left";
            henkan = "overload(control, right)";
          };
        };
      };
    };
  };
}
