;; init.el
;; Author: Lin Jiang

;; ------------------- Basic Interface Tweaks ------------------- ;;

;; Emacs
(setq inhibit-startup-message t)      ; Disable startup screen
(scroll-bar-mode -1)                  ; Disable scrollbar
(tool-bar-mode -1)                    ; Disable toolbar
(tooltip-mode -1)                     ; Disable tooltip
(set-fringe-mode 30)                  ; Give some breathing room
(menu-bar-mode -1)                    ; Disable menubar
(column-number-mode)                  ; Display column numbers
(add-hook 'prog-mode-hook 'display-line-numbers-mode)  ; Display line numbers
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)
(when (fboundp 'electric-indent-mode) (electric-indent-mode -1))

;; Text
(set-face-attribute 'default nil :font "-JB-JetBrainsMono Nerd Font Mono-regular-normal-normal-*-16-*-*-*-m-0-iso10646-1" :height 110)

;; Themes
(load-theme 'catppuccin t)            ; Use theme "Catppuccin"

;; Window movement
(windmove-default-keybindings)

;; Treesitter
(setq treesit-language-source-alist
      '((rust "https://github.com/tree-sitter/tree-sitter-rust")))

;; ------------------- Basic Package Setup ------------------- ;;

;; Setup Packages
(require 'package)      ; package-install

(setq package-archives '(("org" . "https://orgmode.org/elpa/")
			 ("melpa" . "http://melpa.org/packages/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Setup Use-Package
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; ------------------- New Packages ------------------- ;;
;; Rainbow Delimiters
(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode))

;; libvterm
(use-package vterm
  :ensure t)

;; Simple Modeline
(use-package simple-modeline
  :ensure t
  :hook (after-init . simple-modeline-mode))

;; sudo-edit
(use-package sudo-edit
  :ensure t)

;; magit
(use-package magit
  :ensure t)

;; projectile
(use-package projectile
  :ensure t
  :init
  (projectile-mode +1)
  (setq projectile-project-search-path '("~/Projects/" "~/ctf/"))
  :bind (:map projectile-mode-map
	      ("C-c p" . projectile-command-map)))

;; vertico
(use-package vertico
  :ensure t
  :init
  (vertico-mode))

;; orderless
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

;; marginalia
(use-package marginalia
  :ensure t
  :init
  (marginalia-mode))

;; yasnippets
(use-package yasnippet
  :ensure t
  :init
  (yas-global-mode 1))

;; clipmon
(use-package clipmon
  :bind ("s-y" . clipmon-autoinsert-toggle)
  :init (clipmon-mode))

;; hydra
(use-package hydra
  :ensure t
  :defer 2
  :bind ("C-c m" . hydra-move/body))

;; multiple-cursors
(use-package multiple-cursors
  :ensure t
  :bind ("C->" . mc/mark-next-like-this)
  :bind ("C-<" . mc/mark-previous-like-this))

;; ripgrep
(use-package rg
  :ensure t)

;; which-key
(use-package which-key
  :ensure t
  :init
  (which-key-mode))

;; company-mode
(use-package company
  :ensure t
  :init
  (company-mode))
  
;; lsp-mode
(use-package lsp-mode
  :ensure t
  :init
  (setq lsp-keymap-prefix "C-c l")
  :hook (
         (rust-mode . lsp)
         (html-mode . lsp)
         (c-mode . lsp)
         (c++-mode . lsp)
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)

;; wakatime
(use-package wakatime-mode
  :init
  (global-wakatime-mode))

;; ------------------- Hydras ------------------- ;;
(defhydra hydra-move (:color red :prefix-arg current-prefix-arg)
  "Move"
  ("q" nil)
  ("h" backward-char)
  ("j" next-line)
  ("k" previous-line)
  ("l" forward-char)
  ("a" move-beginning-of-line)
  ("e" move-end-of-line)
  ("w" forward-word)
  ("b" backward-word)
  ("M-f" forward-sexp)
  ("M-b" backward-sexp))

;; ------------------- Language Modes ------------------- ;;
;; svelte-mode
(use-package svelte-mode)

;; rust-mode
(use-package rust-mode)

;; python-mode
(use-package python-mode)

;; markdown-mode
(use-package markdown-mode
  :ensure t
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "pandoc")
  :bind (:map markdown-mode-map
              ("C-c C-e" . markdown-do)))

;; typescript-mode
(use-package typescript-mode)

;; ------------------- Keybinds ------------------- ;;
(global-set-key (kbd "C-.") 'set-mark-command)
(global-set-key (kbd "C-c g") 'magit-status)
(global-set-key (kbd "C-c a") 'windmove-left)
(global-set-key (kbd "C-c d") 'windmove-right)
(global-set-key (kbd "C-c w") 'windmove-up) 
(global-set-key (kbd "C-c s") 'windmove-down)

;; ------------------- Org Mode ------------------- ;;

;; setup function
(defun org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (auto-fill-mode 0)
  (visual-line-mode 1))

;; org-mode
(use-package org
  :hook (org-mode . org-mode-setup)
  :config
  (setq org-ellipsis " ▾"
	org-hide-emphasis-markers t))

;; org-bullets
(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))
  
;; Make sure org-indent face is available
(require 'org-indent)

;; Ensure that anything that should be fixed-pitch in Org files appears that way
(set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
(set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
(set-face-attribute 'org-indent nil :inherit '(org-hide fixed-pitch))
(set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
(set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
(set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
(set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(dap-mode web-mode clipmon company which-key multiple-cursors magit wakatime-mode typescript-mode typescript marginalia orderless vertico projectile hydra svelte-mode rust-mode lsp-bridge yasnippet markdown-mode catppuccin-theme org-bullets vterm sudo-edit simple-modeline rainbow-delimiters))
 '(treesit-font-lock-level 4))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'dired-find-alternate-file 'disabled nil)
(put 'set-goal-column 'disabled nil)
