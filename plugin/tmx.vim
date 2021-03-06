" tmx.vim - Send commands remotely to TMUX
" Maintainer:   Tim Phang
" Version:      0.8

if exists('g:loaded_tmx') || &cp
  finish
endif
let g:loaded_tmx = 1

let s:home = expand("<sfile>:p:h:h")
let s:rs_formatters = '/plugin/rspec/*_formatter.rb'
let g:rs_formatter = 'VimQuickfixFormatter'
let g:rs_command = 'rspec -r '.s:home.s:rs_formatters
let g:send_cfile_to_vim_command = s:home.'/plugin/bash/send_cfile_to_vim.sh'

if !exists("g:tmx_vim_progname")
  let g:tmx_vim_progname = v:progname
endif

function! tmx#send(command_string)
  if (!exists("s:tmux_target"))
    let s:session = input("Session: ", "", "custom,tmx#session_names")
    let s:window = substitute(input("Window: ", "", "custom,tmx#window_names"), ':.*$', '', 'g')
    let s:panel = input("Panel: ", "", "custom,tmx#panel_names")
    let s:tmux_target = s:session . ':' . s:window . '.' . s:panel
  endif
  exec 'silent !tmux send-keys -t ' . s:tmux_target . ' "' . a:command_string . '" ENTER'
endfunction

function! tmx#cli()
  if(exists("s:tmux_target"))
    let l:prmpt = 'tmux '.s:tmux_target.': '
  else
    let l:prmpt = 'tmx: '
  endif

  let l:command = input(l:prmpt, "", "shellcmd")

  if(strlen(l:command) > 0)
    call tmx#send(command)
  endif
endfunction

function! tmx#rspec(...)
  let l:f = (a:0) ? a:1 : expand('%')

  let l:errorfile = tempname()

  let l:rs_command = g:rs_command.' '.l:f.' -f d'
  let l:qf_command = tmx#build_cfile_to_vim_command(l:errorfile)

  if(has('clientserver'))
    let l:rs_command = l:rs_command.' -f '.g:rs_formatter.' -o '.l:errorfile.';'.l:qf_command
  end

  call tmx#send(l:rs_command)
endfunction

function! tmx#rubocop(...)
  let l:f = (a:0) ? a:1 : expand('%')

  let l:errorfile = tempname()

  let l:rbc_command = 'rubocop '.l:f
  let l:qf_command = tmx#build_cfile_to_vim_command(l:errorfile)

  if(has('clientserver'))
    let l:rbc_command = l:rbc_command.' -f c -o '.l:errorfile.';'.l:qf_command
  end

  call tmx#send(l:rbc_command)
endfunction

function! tmx#build_cfile_to_vim_command(errorfile)
  return g:send_cfile_to_vim_command.' '.g:tmx_vim_progname.' '.v:servername.' '.a:errorfile
endfunction

function! tmx#session_names(ArgLead, CmdLine, CursorPos)
  return system('tmux list-sessions | sed -e "s/:.*$//"')
endfunction

function! tmx#window_names(ArgLead, CmdLine, CursorPos)
  return system('tmux list-windows -t '.s:session.' | sed -e "s/ \[[0-9x]*\].*$//"')
endfunction

function! tmx#panel_names(ArgLead, CmdLine, CursorPos)
  return system('tmux list-panes -t ' . s:session . ':' . s:window . ' | sed -e "s/:.*$//"')
endfunction

command! -nargs=1 -complete=shellcmd TMXSend call tmx#send("<args>")
command! -nargs=* TMXRspec call tmx#rspec(<f-args>)
command! -nargs=* TMXRubocop call tmx#rubocop(<f-args>)
command! TMXReset :unlet s:tmux_target

:autocmd FileType qf wincmd J
:autocmd FileType qf resize 5

" default ctrl+: binding
map <leader>: :call tmx#cli()<CR>
