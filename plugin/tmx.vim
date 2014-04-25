" tmx.vim - Send commands remotely to TMUX
" Maintainer:   Tim Phang
" Version:      0.8

" if exists('g:loaded_tmx') || &cp
"   finish
" endif
" let g:loaded_tmx = 1

function! tmx#send(command_string)
  if (!exists("s:tmux_target"))
    let l:session = input("Session: ", "")
    let l:window = input("Window: ", "")
    let l:panel = input("Panel: ", "")
    let s:tmux_target = l:session . ':' . l:window . '.' . l:panel
  end
  exec 'silent !tmux send-keys -t ' . s:tmux_target . ' "' . a:command_string . '" ENTER'
endfunction

let s:home = expand("<sfile>:p:h:h")
let s:rs_formatters = '/plugin/rspec/*_formatter.rb'
let g:rs_formatter = 'VimQuickfixFormatter'
let g:rs_command = 'rspec -r '.s:home.s:rs_formatters

function! tmx#rspec(...)
  if(a:0)
    let l:f = a:1
  else
    let l:f = expand('%')
  end
  let l:errorfile = tempname()
  let l:rs_command = g:rs_command.' '.l:f.' -f '.g:rs_formatter.' -o '.l:errorfile.' -f d'
  let l:qf_command = 'if [ -s "'.l:errorfile.'" ]; then mvim --servername '.v:servername.' --remote-send ''<ESC>:cg '.l:errorfile.'|copen<CR>'';fi'
  call tmx#send(l:rs_command. ';'.l:qf_command)
endfunction

command! -nargs=1 -complete=shellcmd TMXSend call tmx#send("<args>")
command! -nargs=* TMXRspec call tmx#rspec(<f-args>)
command! TMXReset :unlet s:tmux_target

:autocmd FileType qf wincmd J
:autocmd FileType qf resize 5
