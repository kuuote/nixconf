#!/usr/bin/env -S bash -u

while true; do
  if [[ $(git -C ~/.vim rev-parse @) != $(git -C ~/.vim rev-parse @{u}) ]]; then
    push=pushしなさいっ！
  else
    push=
  fi

  echo ${push} $(date +%T) $(acpi -i | head -n1 | grep -Po '\d+%')
  sleep 1
done
