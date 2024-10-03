{
  # cd_from_app = {
  #   body = ''
  # if test -e /tmp/fish_cd
  #   cd (cat /tmp/fish_cd)
  #   rm /tmp/fish_cd
  # end
  #   '';
  #   event = "fish_postexec";
  # }

  # original: mkcd
  # https://github.com/NI57721/dotfiles/blob/d390df8575fd9a96ffbd389b57c72838ffb6c3e1/.config/fish/config.fish?plain=1#L153-L158
  take = ''
    mkdir -p $argv[1]
    and cd $argv[1]
    and pwd
  '';
}
