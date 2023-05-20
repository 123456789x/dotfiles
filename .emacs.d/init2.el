;;; init.el
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
(global-display-line-numbers-mode t)  ; Display line numbers
;; (set-face-attribute 'default t :font "-*-Fira Mono-normal-normal-normal-*-*-*-*-*-m-0-iso10646-1") ; Set font to Fira Mono

;; Themes
(add-to-list 'custom-theme-load-path (expand-file-name "~/.emacs.d/themes/"))
(load-theme 'nord t)            ; Use theme "Nord"


;; ------------------- Basic Package Setup ------------------- ;;

;; Setup Packages
(require 'package)      ; package-install

(setq package-archives '(("org" . "https://orgmode.org/elpa/")
			 ("melpa-stable" . "http://stable.melpa.org/packages/")
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
  :hook (prog-mode . rainbow-delimiters-mode))
