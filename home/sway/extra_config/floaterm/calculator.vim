function s:calc() abort
  let rx = 1920
  let ry = 1080
  let x = rx * 3 / 4
  let y = ry * 3 / 4
  echo [x, y]
  echo [x / getcellpixels()[0], y / getcellpixels()[1]]
endfunction

call s:calc()
