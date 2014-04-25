# tmx.vim
TMUX remote command execution from VIM. Includes shorthand for running rspec tests. This plugin is similar but less feature-rich than Tim Pope's [vim-dispatch][dispatch].

[dispatch]: https://github.com/tpope/vim-dispatch

## Installation
**Pathogen**
```
cd ~/.vim/bundle
git clone git@github.com:tphang/vim-tmx.git
```

## Usage
**tmx#send()**  
Sending a command to a tmux session is as simple as `:TMXSend ls`. This will prompt you for tmux target info (sesion, window and panel) and fire off the command. A target will be remembered for the duration of your VIM session. To select a different target send `:TMXReset` and then your new target.

**tmx#rspec()**  
To kick off an rspec test run issue `:TMXRspec` with an optional filename. This will run rspec in your target tmux session with a vim formatter. Any resulting failures will be pushed into a VIM [quickfix][vim-quickfix] window. In order for this to work, you must have vim compiled with the +clientserver option. Most GUI versions of vim have are compiled with this option. If you are running multiple versions of vim and you have not linked vim to mvim, you may need to add `let g:tmx_vim_progname=mvim` by default it is set to [v:progname][vim-progname]

[vim-quickfix]: http://vimdoc.sourceforge.net/htmldoc/quickfix.html
[vim-progname]: http://vimdoc.sourceforge.net/htmldoc/eval.html#v:progname
