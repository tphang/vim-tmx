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
###tmx#send()
Sending a command to a tmux session is as simple as `:TMXSend ls`. This will prompt you for tmux target info (sesion, window and panel) and fire off the command. A target will be remembered for the duration of your VIM session. To select a different target send `:TMXReset` and then your new target.

###tmx#rspec()
To kick off an rspec test run issue `:TMXRspec` with an optional filename. If no filename is provided, the current file will be used. To run the whole test suite use `:TMXRspec .`. This will run rspec in your target tmux session and give you a summary of the results. If you have vim compiled with the _+clientserver_ option, any resulting failures will be pushed into a VIM [quickfix][vim-quickfix] window. Most GUI versions of vim have are compiled with this option. If you are running multiple versions of vim and you have not linked vim to mvim, you may need to add `let g:tmx_vim_progname=mvim` by default it is set to [v:progname][vim-progname]. Run `:cope[n]` to toggle the quickfix window open and jump to the first error.

[vim-quickfix]: http://vimdoc.sourceforge.net/htmldoc/quickfix.html
[vim-progname]: http://vimdoc.sourceforge.net/htmldoc/eval.html#v:progname

###tmx#rubocop()
To start an async rubocop run issue `:TMXRubocop` with an optional filename. If no filename is provided, the current file will be used. To run rubocop accross an entire project use `:RMXRspec .`. Similar to rspec, rubocop will also to output a [quickfix][vim-quickfix] file if you have vim compiled with _+clientserver_.

###Example Mappings###
By default, this plugin does not include any mappings but it can be especially useful for anything you do repeatedly. Add the following to your `~/.vimrc`.

```vimrc
"<leader>t to test current file
map <leader>t :TMXRspec<CR>

"<leader>s to syntax check current file
map <leader>s :TMXRubocop<CR>
```
