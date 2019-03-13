;;; Disable gui stuff
;; Disable scroll bar all frames
(defun my/disable-scroll-bars (frame)
  (modify-frame-parameters frame
                           '((vertical-scroll-bars . nil)
                             (horizontal-scroll-bars . nil))))
(add-hook 'after-make-frame-functions 'my/disable-scroll-bars)

(menu-bar-mode -1)
(tool-bar-mode -1)
(blink-cursor-mode 0)

;; Other settings
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

;; use-package configuration
(require 'use-package-ensure)
(setq use-package-always-ensure t)

;; Packages
(use-package haskell-mode
  :config
	(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)

	;; Ignore compiled Haskell files in filename completions
	(add-to-list 'completion-ignored-extensions ".hi")

	(setq haskell-process-type 'stack-ghci)
	(setq haskell-process-log t)

	;; https://github.com/rexim/dotfiles/blob/master/.emacs.rc/haskell-mode-rc.el
	(add-hook 'haskell-mode-hook 'haskell-indent-mode)
	(add-hook 'haskell-mode-hook 'interactive-haskell-mode)
	(add-hook 'haskell-mode-hook 'haskell-doc-mode)
  :bind (:map haskell-mode-map
	("C-c C-l" . haskell-process-load-or-reload)
    ("C-c C-z" . haskell-interactive-switch))
  )
(use-package markdown-mode )
(use-package lua-mode)
(use-package rust-mode)
(use-package go-mode
  :config
	(add-hook 'before-save-hook 'gofmt-before-save)
	(setq gofmt-command "goimports"))

(use-package flycheck
  :config
	(setq flycheck-check-syntax-automatically '(mode-enabled save))
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
        (define-key evil-normal-state-map (kbd ",gd") 'godef-jump)
        )
    )

;; org-mode packages
(use-package htmlize)
(use-package ob-go)
(use-package ob-rust)
(use-package org-bullets
  :config
    ;; Enable org-bullets in org mode
	(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

;; All the themes
(use-package gruber-darker-theme)
;;(use-package spacemacs-theme)
;;(use-package gruvbox-theme)
;;(use-package solarized-theme)

;; org-mode settings
(setq org-hide-emphasis-markers t)
(setq org-src-tab-acts-natively t)

;; Setup automatically by emacs
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(compilation-message-face (quote default))
 '(cua-global-mark-cursor-color "#2aa198")
 '(cua-normal-cursor-color "#839496")
 '(cua-overwrite-cursor-color "#b58900")
 '(cua-read-only-cursor-color "#859900")
 '(custom-enabled-themes (quote (gruber-darker)))
 '(custom-safe-themes
   (quote
	("fa2b58bb98b62c3b8cf3b6f02f058ef7827a8e497125de0254f56e373abee088" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" "47ec21abaa6642fefec1b7ace282221574c2dd7ef7715c099af5629926eb4fd7" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default)))
 '(fci-rule-color "#073642")
 '(frame-brackground-mode (quote dark))
 '(highlight-changes-colors (quote ("#d33682" "#6c71c4")))
 '(highlight-symbol-colors
   (--map
	(solarized-color-blend it "#002b36" 0.25)
	(quote
	 ("#b58900" "#2aa198" "#dc322f" "#6c71c4" "#859900" "#cb4b16" "#268bd2"))))
 '(highlight-symbol-foreground-color "#93a1a1")
 '(highlight-tail-colors
   (quote
	(("#073642" . 0)
	 ("#546E00" . 20)
	 ("#00736F" . 30)
	 ("#00629D" . 50)
	 ("#7B6000" . 60)
	 ("#8B2C02" . 70)
	 ("#93115C" . 85)
	 ("#073642" . 100))))
 '(hl-bg-colors
   (quote
	("#7B6000" "#8B2C02" "#990A1B" "#93115C" "#3F4D91" "#00629D" "#00736F" "#546E00")))
 '(hl-fg-colors
   (quote
	("#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36")))
 '(hl-paren-colors (quote ("#2aa198" "#b58900" "#268bd2" "#6c71c4" "#859900")))
 '(hl-todo-keyword-faces
   (quote
	(("TODO" . "#dc752f")
	 ("NEXT" . "#dc752f")
	 ("THEM" . "#2d9574")
	 ("PROG" . "#4f97d7")
	 ("OKAY" . "#4f97d7")
	 ("DONT" . "#f2241f")
	 ("FAIL" . "#f2241f")
	 ("DONE" . "#86dc2f")
	 ("NOTE" . "#b1951d")
	 ("KLUDGE" . "#b1951d")
	 ("HACK" . "#b1951d")
	 ("TEMP" . "#b1951d")
	 ("FIXME" . "#dc752f")
	 ("XXX" . "#dc752f")
	 ("XXXX" . "#dc752f")
	 ("???" . "#dc752f"))))
 '(inhibit-startup-screen t)
 '(magit-diff-use-overlays nil)
 '(nrepl-message-colors
   (quote
	("#dc322f" "#cb4b16" "#b58900" "#546E00" "#B4C342" "#00629D" "#2aa198" "#d33682" "#6c71c4")))
 '(package-selected-packages
   (quote
	(pacmacs htmlize markdown-mode flycheck evil-leader rust-mode ob-rust ob-ruby ob-go org-bullets go-autocomplete auto-complete fzf haskell-snippets helm use-package ## lua-mode go-mode haskell-mode gruber-darker-theme evil-visual-mark-mode)))
 '(pdf-view-midnight-colors (quote ("#b2b2b2" . "#292b2e")))
 '(pos-tip-background-color "#073642")
 '(pos-tip-foreground-color "#93a1a1")
 '(smartrep-mode-line-active-bg (solarized-color-blend "#859900" "#073642" 0.2))
 '(term-default-bg-color "#002b36")
 '(term-default-fg-color "#839496")
 '(vc-annotate-background nil)
 '(vc-annotate-background-mode nil)
 '(vc-annotate-color-map
   (quote
	((20 . "#dc322f")
	 (40 . "#c8805d801780")
	 (60 . "#bec073400bc0")
	 (80 . "#b58900")
	 (100 . "#a5008e550000")
	 (120 . "#9d0091000000")
	 (140 . "#950093aa0000")
	 (160 . "#8d0096550000")
	 (180 . "#859900")
	 (200 . "#66aa9baa32aa")
	 (220 . "#57809d004c00")
	 (240 . "#48559e556555")
	 (260 . "#392a9faa7eaa")
	 (280 . "#2aa198")
	 (300 . "#28669833af33")
	 (320 . "#279993ccbacc")
	 (340 . "#26cc8f66c666")
	 (360 . "#268bd2"))))
 '(vc-annotate-very-old-color nil)
 '(weechat-color-list
   (quote
	(unspecified "#002b36" "#073642" "#990A1B" "#dc322f" "#546E00" "#859900" "#7B6000" "#b58900" "#00629D" "#268bd2" "#93115C" "#d33682" "#00736F" "#2aa198" "#839496" "#657b83")))
 '(xterm-color-names
   ["#073642" "#dc322f" "#859900" "#b58900" "#268bd2" "#d33682" "#2aa198" "#eee8d5"])
 '(xterm-color-names-bright
   ["#002b36" "#cb4b16" "#586e75" "#657b83" "#839496" "#6c71c4" "#93a1a1" "#fdf6e3"]))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;; .emacs ends here
