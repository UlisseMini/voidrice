(menu-bar-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)
(blink-cursor-mode 0)
(setq-default tab-width 4)

;; Set transparency of emacs
(defun transparency (value)
	"Sets the transparency of the frame window. 0=transparent/100=opaque"
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

;; Install org-bullets (use-package was throwing an error)
(unless (package-installed-p 'org-bullets)
  (package-refresh-contents)
  (package-install 'org-bullets))

;; Org mode settings
(setq org-hide-emphasis-markers t)
(setq org-src-tab-acts-natively t)
;; Make bullets VeRyNiCe
(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

;; Packages
(use-package haskell-mode)
(use-package lua-mode)
(use-package auto-complete
  :config
    (ac-config-default)
  )
(use-package go-mode
  :config
	(add-hook 'before-save-hook 'gofmt-before-save) ; gofmt before every save
	(setq gofmt-command "goimports")                ; gofmt uses invokes goimports
  )
(use-package helm
  :config
	;; Enable helm
	(require 'helm-config)
	(helm-mode 1)
  )

(use-package evil
  :config
	;; Enable evil-mode
	;;(require 'evil)

	(evil-mode t)
	(setq evil-want-C-i-jump nil)
  )

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
	(org-bullets go-autocomplete auto-complete fzf haskell-snippets helm use-package ## lua-mode go-mode solarized-theme haskell-mode gruber-darker-theme evil-visual-mark-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Enable my theme
(load-theme 'gruber-darker)
