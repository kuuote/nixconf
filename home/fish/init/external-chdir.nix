''
function external_chdir --on-event fish_postexec
  if test -e /tmp/fish_cd
    cd (cat /tmp/fish_cd)
    rm /tmp/fish_cd
  end
end
''
