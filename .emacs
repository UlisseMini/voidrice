(require 'package)

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))
;; Set up package repositories so M-x package-install works.
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(load-theme 'gruvbox-dark-hard)       ; Color theme installed via melpa

;; evil mode by default
(require 'evil)
(evil-mode t)

;; tabsize
(setq-default tab-width 4)

;; make it terminal only
(menu-bar-mode 0)
(tool-bar-mode 0)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#3c3836" "#fb4933" "#b8bb26" "#fabd2f" "#83a598" "#d3869b" "#8ec07c" "#ebdbb2"])
 '(custom-safe-themes
   (quote
	("a622aaf6377fe1cd14e4298497b7b2cae2efc9e0ce362dade3a58c16c89e089c" "2a9039b093df61e4517302f40ebaf2d3e95215cb2f9684c8c1a446659ee226b9" "e2fd81495089dc09d14a88f29dfdff7645f213e2c03650ac2dd275de52a513de" "adf5275cc3264f0a938d97ded007c82913906fc6cd64458eaae6853f6be287ce" default)))
 '(fci-rule-color "#3E4451")
 '(package-selected-packages
   (quote
	(gruvbox-theme go-mode go-autocomplete flymake-go exec-path-from-shell evil-visual-mark-mode atom-one-dark-theme)))
 '(pdf-view-midnight-colors (quote ("#fdf4c1" . "#282828")))
 '(tetris-x-colors
   [[229 192 123]
	[97 175 239]
	[209 154 102]
	[224 108 117]
	[152 195 121]
	[198 120 221]
	[86 182 194]]))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(defadvice tetris-end-game (around zap-scores activate)
  (save-window-excursion ad-do-it))
