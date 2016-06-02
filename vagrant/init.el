(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(add-to-list 'load-path "~/.emacs.d/lisp/synquid-mode/")

(setq-default inhibit-startup-screen t)

;; Font fallback
(when (functionp 'set-fontset-font)
  (set-face-attribute 'default nil :family "Ubuntu Mono")
  (dolist (ft (fontset-list))
    (set-fontset-font ft 'unicode (font-spec :name "Ubuntu Mono"))
    (set-fontset-font ft 'unicode (font-spec :name "Symbola monospacified for Ubuntu Mono") nil 'append)))

;; Basic usability
(xterm-mouse-mode)
(load-theme 'tango-dark t)

;; Open Synquid files in synquid-mode
(add-to-list 'auto-mode-alist '("\\.sq\\'" . synquid-mode))
