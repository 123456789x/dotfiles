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

;; Themes
(add-to-list 'custom-theme-load-path (expand-file-name "~/.emacs.d/themes/"))
(load-theme 'nord t)            ; Use theme "Nord"


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
  :hook (prog-mode . rainbow-delimiters-mode))

;; libvterm
(use-package vterm
  :ensure t)

;; Simple Modeline
(use-package simple-modeline
  :hook (after-init . simple-modeline-mode))

;; sudo-edit
(use-package sudo-edit)


;; ------------------- Window Manager ------------------- ;;

;; exwm
(require 'exwm)
(require 'exwm-config)
(exwm-config-example)



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





;; ------------------- Custom Set Variables ------------------- ;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(org-bullets exwm vterm use-package simple-modeline rainbow-delimiters nord-theme))
 '(warning-suppress-types '((comp))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; init.el ends here
