(menu-bar-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)
(blink-cursor-mode 0)
(setq-default tab-width 4)

(setq backup-directory-alist `(("." . "~/.emacs_backup")))

;; Add go/bin to the path
(setenv "PATH" (concat (getenv "PATH") "~/go/bin"))
(setq exec-path (append exec-path '("~/go/bin")))

;; generate ctags
(setq path-to-ctags "/usr/bin/ctags")

(defun create-tags (dir-name)
"Create tags file."
(interactive "DDirectory: ")
(shell-command
	(format "%s -f TAGS -e -R %s" path-to-ctags (directory-file-name dir-name)))
)

;; Set transparency of emacs
(defun transparency (value)
	"Sets the transparency of the frame window.  0=transparent/100=opaque"
	(interactive "nTransparency Value 0 - 100 opaque:")
	(set-frame-parameter (selected-frame) 'alpha value))

;; Setup package management
(require 'package)

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))


(setq package-enable-at-startup nil)
(package-initialize)

;; install use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

;; Packages
(use-package haskell-mode :ensure
  :config
	(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)

	;; Ignore compiled Haskell files in filename completions
	(add-to-list 'completion-ignored-extensions ".hi")

	;; https://github.com/rexim/dotfiles/blob/master/.emacs.rc/haskell-mode-rc.el
	(setq haskell-process-type 'stack-ghci)
	(setq haskell-process-log t)

	(add-hook 'haskell-mode-hook 'haskell-indent-mode)
	(add-hook 'haskell-mode-hook 'interactive-haskell-mode)
	(add-hook 'haskell-mode-hook 'haskell-doc-mode)
	(add-hook 'haskell-mode-hook 'hindent-mode)
  )
(use-package lua-mode     :ensure)
(use-package rust-mode    :ensure)
(use-package go-mode      :ensure
  :config
	(add-hook 'before-save-hook 'gofmt-before-save)
	(setq gofmt-command "goimports"))

(use-package flycheck :ensure
  :config
	(add-hook 'after-init-hook #'global-flycheck-mode)
  )
(use-package helm
  :config
	;; Enable helm
	(require 'helm-config)
	(helm-mode 1))

(use-package auto-complete
  :config
    (ac-config-default))

(use-package evil
  :config
	;; Enable evil-mode
	(evil-mode t)
	(setq evil-want-C-i-jump nil)

    ;; Remaps
    (with-eval-after-load 'evil-maps
        ;; TODO: Find a way to bind stuff to <SPACE>+prefix
        (define-key evil-normal-state-map "gd" nil)
        ;; (define-key evil-normal-state-map "gd" 'xref-find-definitions)
        (define-key evil-normal-state-map (kbd ",gd") 'godef-jump)
        )
    )

;; org-mode packages
(use-package ob-go :ensure)
(use-package ob-rust :ensure)
(use-package org-bullets
  :ensure
  :config
    ;; Enable org-bullets in org mode
	(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

;; org-mode settings
(setq org-hide-emphasis-markers t)
(setq org-src-tab-acts-natively t)

;; Setup automatically by emacs
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
	("47ec21abaa6642fefec1b7ace282221574c2dd7ef7715c099af5629926eb4fd7" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default)))
 '(inhibit-startup-screen t)
 '(package-selected-packages
   (quote
	(flycheck evil-leader rust-mode ob-rust ob-ruby ob-go org-bullets go-autocomplete auto-complete fzf haskell-snippets helm use-package ## lua-mode go-mode solarized-theme haskell-mode gruber-darker-theme evil-visual-mark-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Enable my theme
(load-theme 'gruber-darker)
