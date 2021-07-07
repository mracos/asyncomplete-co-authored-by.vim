function! g:asyncomplete_m#sources#co_authored_by#completor(opt, ctx) abort
  let l:keyword = "Co-authored-by: "

  let l:typed = a:ctx['typed']
  let l:col = a:ctx['col']
  let l:kw = matchstr(l:typed, '\k\+$')
  let l:startcol = l:col - len(l:kw)

  let l:matches = []

  if (l:keyword =~ l:typed)
    " Also add Co-authored-by prefix to authors name
    let l:matches += map(
          \ systemlist('git shortlog --summary --email --all 2>/dev/null | cut -f2 | uniq | sort'),
          \ {_idx, val -> l:keyword . val})
  endif

  " Remove what we already typed
  let l:matches = map(l:matches, {_idx, val -> substitute(val, l:typed, '', '')})
  call asyncomplete#complete(a:opt['name'], a:ctx, l:startcol, l:matches)
endfunction
