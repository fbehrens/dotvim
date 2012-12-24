function! g:TmuxSend( text)
  call system("tmux load-buffer -". a:text)
  call system("tmux paste-buffer -t " . shellescape(g:TmuxAlternatePane()))
endfunction

function! g:TmuxAlternatePane()
    let panes= split(system("tmux list-panes -F '#{pane_active} #{session_name}:#{window_index}.#{pane_index}'"),"\n")
    for pane in panes
      if matchstr(pane,'^1')
        let pattern = '0'.strpart(pane,1,strlen(pane)-3)
      end
    endfor
    for pane in panes
        if strlen(matchstr(pane,pattern))
            let alternate =  strpart(pane,2)
        endif
    endfor
    return alternate
")
endfunction
" Helpers
function! g:_EscapeText(text)
  if exists("&filetype")
    let custom_escape = "_EscapeText_" . &filetype
    if exists("*" . custom_escape)
        let result = call(custom_escape, [a:text])
    end
  end

  " use a:text if the ftplugin didn't kick in
  if !exists("result")
    let result = a:text
  end
  " return an array, regardless
  if type(result) == type("")
    return [result]
  else
    return result
  end
endfunction

function! g:SlimeSend(text)
  let pieces = g:_EscapeText(a:text)
  for piece in pieces
    call g:TmuxSend(piece)
  endfor
endfunction

function! g:SlimeLine()
  exe "norm! yy"
  call g:TmuxSend(@")
endfunction
map ,s :call g:SlimeLine()<CR>
