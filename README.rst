================
``synquid-mode``
================

Write Synquid programs in Emacs!

Setup
=====

- Add MELPA: put the following in your ``.emacs`` (if you don't have it yet)::

    (require 'package)
    (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
    (package-initialize)

- Install the ``synquid`` package: ``M-x package-refresh-contents RET`` then ``M-x package-install RET synquid``
