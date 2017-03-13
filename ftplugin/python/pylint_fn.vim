" File: pylint_fn.vim
" Author: Roman 'gryf' Dobosz (gryf73 at gmail.com)
" Version: 1.2
" Last Modified: 2016-12-10
"
" Description: " {{{
"
" Overview
" --------
" This plugin provides ":Pylint" command, which put pylint result into quickfix
" buffer. This function does not uses pylint[1] command line utility, only
" python pylint.lint module is used instead. So it makes the pylint
" egg/package required for running this script.
"
" This script uses python, therefore VIm should be compiled with python
" support. You can check it by issuing ":version" command, and search for
" "+python" or "+python3" inside features list.
"
" Couple of ideas was taken from pyflakes.vim[2] plugin.
"
" Installation
" ------------
" 1. Copy the pylint_fn.vim file to the $HOME/.vim/ftplugin/python or
"    $HOME/vimfiles/ftplugin/python or $VIM/vimfiles/ftplugin/python
"    directory. If python directory doesn't exists, it should be created.
"    Refer to the following Vim help topics for more information about Vim
"    plugins:
"       :help add-plugin
"       :help add-global-plugin
"       :help runtimepath
" 2. It should be possible to import pylint from python interpreter (it should
"    report no error):
"    >>> import pylint
"    >>>
"    If there are errors, install pylint first. Simplest way to do it, is to
"    use easy_install[3] shell command as a root:
"    # easy_install pylint
" 3. Restart Vim.
" 4. You can now use the ":Pylint" which will examine current python buffer
"    and open quickfix buffer with errors if any.
"
" [1] http://www.logilab.org/project/pylint
" [2] http://www.vim.org/scripts/script.php?script_id=2441
" [3] http://pypi.python.org/pypi/setuptools
" }}}

let s:plugin_path = expand('<sfile>:p:h', 1)

if exists(":Pylint")
    finish " only load once
endif

function! s:SetPython(msg)
    if !exists('g:_python')
        if has('python')
            let g:_python = {'exec': 'python', 'file': 'pyfile'}
        elseif has('python3')
            let g:_python = {'exec': 'python3', 'file': 'py3file'}
        else
            echohl WarningMsg|echomsg a:msg|echohl None
            finish
        endif
    endif
endfunction

function! s:LoadPylint()
    let plugin_path = expand('<sfile>:p:h', 1)
    if !exists('g:pylint_fn_initialized ')
        call s:SetPython("Pylint command cannot be initialized - "
                    \ . "no python support compiled in vim.")
        execute g:_python['file'] . ' ' . s:plugin_path . '/pylint_fn.py'
        let g:pylint_fn_initialized = 1
    endif
endfunction

call s:LoadPylint()

function s:Pylint()
    execute g:_python['exec'] . ' VImPylint.run()'
endfunction
command Pylint call s:Pylint()
