Pylint-vim
==========

This is simple vim plugin, which provide command ``:Pylint`` which check for
linting issues in python code on current buffer.

Unlike any other available *vim-pylint* plugins, it doesn't parse output of
``pylint`` command line tool, but relies on ``pylint`` module, so it make that
dependency on this plugin.

This plugin is kind of deprecated, although I used to use it very often. As an
alternative you can consider Syntastic_.

Installation
------------

To use this plugin either ``+python`` or ``+python3`` feature compiled in vim is
required. To check it, issue ``:version`` in vim instance and look for python
entries.

To install it, any kind of Vim package manager can be used, like NeoBundle_,
Pathogen_, Vundle_ or vim-plug_.

For manual installation, copy subdirectories from this repository to your
``~/.vim`` directory.

Now you'll have new command ``:Pylint`` which in case of any errors or warnings
will display quickfix window with appropriate errors.

License
-------

This work is licensed on 3-clause BSD license. See LICENSE file for details.

.. _Pathogen: https://github.com/tpope/vim-pathogen
.. _Vundle: https://github.com/gmarik/Vundle.vim
.. _NeoBundle: https://github.com/Shougo/neobundle.vim
.. _vim-plug: https://github.com/junegunn/vim-plug
.. _Syntastic: https://github.com/vim-syntastic/syntastic
