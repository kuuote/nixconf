{
  pkgs,
}:
# https://www.reddit.com/r/fishshell/comments/t8xssl/comment/hzu7fil/
''
  function record_dirprev --on-variable dirprev
    if test "$dirprev[1]" != ""
      ${pkgs.python3}/bin/python ${./.}/mru.py ~/.stack $dirprev[1]
      ${pkgs.python3}/bin/python ${./.}/mru.py ~/.stack $PWD
    end
  end

  function record_pwd --on-variable PWD
    ${pkgs.python3}/bin/python ${./.}/mru.py ~/.stack $PWD
  end

  function m
    cd (cat ~/.stack | ${pkgs.fzf}/bin/fzf --scheme history)
  end
''
