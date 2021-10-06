;; ------------------- Basic Interface Tweaks ------------------- ;;

;; Emacs
(setq inhibit-startup-message t)      ; Disable startup screen
(scroll-bar-mode -1)                  ; Disable scrollbar
(tool-bar-mode -1)                    ; Disable toolbar
(tooltip-mode -1)                     ; Disable tooltip
(set-fringe-mode 15)                  ; Give some breathing room
(menu-bar-mode -1)                    ; Disable menubar

(set-face-attribute 'default nil :height 130)      ; Larger font size
(load-theme 'doom-wilmersdorf t)                   ; Use Doom inspired theme "Wilmersdorf"

;; Setup Packages
(require 'package)      ; package-install

(setq package-archives '(("melpa" . "https://melpa.org/packages/")         ; set package archives
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))

;; Setup Use-Package
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)


;; Modeline
(use-package doom-modeline           ; Use Doom inspired modeline
  :ensure t
  :init (doom-modeline-mode 1))

(setq doom-modeline-height 38)       ; Larger height for modeline

;; Set PATH
(setenv "PATH" "~/Documents/Belder/:/opt/local/bin:/opt/local/sbin:/usr/local/Cellar/ffmpeg/4.3.1_8/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/:/usr/local/Cellar/ffmpeg/4.3.1_4/bin :/usr/local/lib:/usr/local/share:/usr/local/Cellar/asymptote/2.70/bin :/Library/TeX/texbin:/usr/local/go/bin:/Library/Apple/usr/bin)")

;; ------------------- New Packages ------------------- ;;

;; Ivy, Swiper, Counsel
(ivy-mode 1)                          ; Enable ivy
(setq ivy-use-virtual-buffers t)      ; Show recent files when switching buffers

;; General.el
(require 'general)             ; Use general.el for keybindings
(general-auto-unbind-keys)     ; Automatically unbind keys when necessary

;; ------------------- Custom ------------------- ;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(general counsel doom-modeline use-package doom-themes)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; ------------------- Key Bindings ------------------- ;;

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(general-define-key
 :prefix "C-s"
 "i" 'isearch-forward
 "f" 'swiper)

;; ------------------- New Functions ------------------- ;;

(defun make-shell (name)
  "Create an eshell buffer named NAME."
  (interactive "sName: ")
  (setq name (concat "$" name))
  (eshell)
  (rename-buffer name))

(defun mas-search (name)
  "Search the Mac App Store."
  (interactive "sName: ")
  (message "%s" (shell-command-to-string (format "mas search %s" (concat (concat "'" name) "'")))))

(defun mas-install (code)
  "Install from the Mac App Store."
  (interactive "sCode: ")
  (shell-command (format "mas install %s" code)))
