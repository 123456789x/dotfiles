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
(set-face-attribute 'default t :font "-*-Fira Mono-normal-normal-normal-*-*-*-*-*-m-0-iso10646-1") ; Set font to Fira Mono

;; Set transparency
(set-frame-parameter (selected-frame) 'alpha '(90 90))

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
		term-mode-hook
		shell-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(set-face-attribute 'default nil :height 140)      ; Larger font size
(load-theme 'doom-wilmersdorf t)                   ; Use Doom inspired theme "Wilmersdorf"

;; Setup Packages
(require 'package)      ; package-install

(setq package-archives '(("org" . "https://orgmode.org/elpa/")
			 ("melpa-stable" . "http://stable.melpa.org/packages/")
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

(setq doom-modeline-height 45)       ; Larger height for modeline

;; Set PATH
(setenv "PATH" "~/Documents/Belder/:/opt/local/bin:/opt/local/sbin:/usr/local/Cellar/ffmpeg/4.3.1_8/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/:/usr/local/Cellar/ffmpeg/4.3.1_4/bin :/usr/local/lib:/usr/local/share:/usr/local/Cellar/asymptote/2.70/bin :/Library/TeX/texbin:/usr/local/go/bin:/Library/Apple/usr/bin)")
(setenv "PKG_CONFIG_PATH" "/usr/local/Cellar/zlib/1.2.8/lib/pkgconfig:/usr/local/lib/pkgconfig:/opt/X11/lib/pkgconfig")

;; ------------------- New Packages ------------------- ;;

;; Ivy, Swiper, Counsel
(ivy-mode 1)                          ; Enable ivy
(setq ivy-use-virtual-buffers t)      ; Show recent files when switching buffers

;; General.el
(use-package general             	; Use general.el for keybindings
  :config      
  (general-auto-unbind-keys))           ; Automatically unbind keys when necessary

;; Rainbow Delimiters
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; Projectile
(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p "~/Documents/Programming")
    (setq projectile-project-search-path '("~/Documents/Programming")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

;; Magit
(use-package magit)

;; EPeriodic
(add-to-list 'load-path "~/.emacs.d/site-lisp")
(require 'eperiodic)


;; Org-Drill
(use-package org-drill)



;; ------------------- Custom ------------------- ;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(exwm org-mode magit counsel-projectile projectile hydra rainbow-delimiters general counsel doom-modeline use-package doom-themes)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; ------------------- Key Bindings ------------------- ;;

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(global-set-key (kbd "C-c c") 'org-capture)

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

;; ------------------- Org-Mode ------------------- ;;

;; set agenda files
(setq org-agenda-files (quote ("~/.plans/Tasks"
			       "~/.plans/Plans/Boy Scouts"
			       "~/.plans/Plans/High Learning"
			       )))

;; set todo keywords
(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "NEXT(n)" "PROG(p)" "|" "DONE(d@)")
              (sequence "WAIT(w/!)" "|" "CANC(c@/!)"))))

(setq org-todo-keyword-faces nil)

(setq org-log-into-drawer t)

(setq org-directory "~/.plans")
(setq org-default-notes-file "~/.plans/refile.org")

;; Capture templates for: TODO tasks, Notes, appointments, phone calls, meetings, and org-protocol
(setq org-capture-templates
      (quote (("t" "todo" entry (file "~/.plans/refile.org")
               "* TODO %?\n%U\n%a\n" :clock-in t :clock-resume t)
              ("r" "respond" entry (file "~/.plans/refile.org")
               "* NEXT Respond to %:from on %:subject\nSCHEDULED: %t\n%U\n%a\n" :clock-in t :clock-resume t :immediate-finish t)
              ("n" "note" entry (file "~/.plans/refile.org")
               "* %? :NOTE:\n%U\n%a\n" :clock-in t :clock-resume t))))

;; Remove empty LOGBOOK drawers on clock out
(defun bh/remove-empty-drawer-on-clock-out ()
  (interactive)
  (save-excursion
    (beginning-of-line 0)
    (org-remove-empty-drawer-at "LOGBOOK" (point))))

(add-hook 'org-clock-out-hook 'bh/remove-empty-drawer-on-clock-out 'append)

;; Change UI for ellipsis
(setq org-ellipsis " ▾")

;; Change UI for stars
(use-package org-superstar
  :after org
  :hook (org-mode . org-superstar-mode)
  :custom
  (org-superstar-remove-leading-stars t)
  (org-superstar-headline-bullets-list '("◉" "○" "●" "○" "●" "○" "●")))

;; Increase the size of various headings
(set-face-attribute 'org-document-title nil :font "-*-Avenir-normal-normal-normal-*-12-*-*-*-p-0-iso10646-1" :weight 'bold :height 1.3)
(dolist (face '((org-level-1 . 1.2)
                (org-level-2 . 1.1)
                (org-level-3 . 1.05)
                (org-level-4 . 1.0)
                (org-level-5 . 1.1)
                (org-level-6 . 1.1)
                (org-level-7 . 1.1)
                (org-level-8 . 1.1)))
  (set-face-attribute (car face) nil :font "-*-Avenir-normal-normal-normal-*-12-*-*-*-p-0-iso10646-1" :weight 'medium :height (cdr face)))

;; Make sure org-indent face is available
(require 'org-indent)

;; Ensure that anything that should be fixed-pitch in Org files appears that way
(set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
(set-face-attribute 'org-table nil  :inherit 'fixed-pitch)
(set-face-attribute 'org-formula nil  :inherit 'fixed-pitch)
(set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
(set-face-attribute 'org-indent nil :inherit '(org-hide fixed-pitch))
(set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
(set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
(set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
(set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch)

;; Get rid of the background on column views
(set-face-attribute 'org-column nil :background nil)
(set-face-attribute 'org-column-title nil :background nil)

; Targets include this file and any file contributing to the agenda - up to 9 levels deep
(setq org-refile-targets (quote ((nil :maxlevel . 9)
                                 (org-agenda-files :maxlevel . 9))))

; Use full outline paths for refile targets - we file directly with IDO
(setq org-refile-use-outline-path t)

; Targets complete directly with IDO
(setq org-outline-path-complete-in-steps nil)

; Allow refile to create parent tasks with confirmation
(setq org-refile-allow-creating-parent-nodes (quote confirm))

; Use IDO for both buffer and file completion and ido-everywhere to t
(setq org-completion-use-ido t)
(setq ido-everywhere t)
(setq ido-max-directory-size 100000)
(ido-mode (quote both))
; Use the current window when visiting files and buffers with ido
(setq ido-default-file-method 'selected-window)
(setq ido-default-buffer-method 'selected-window)
; Use the current window for indirect buffer display
(setq org-indirect-buffer-display 'current-window)

;;;; Refile settings
; Exclude DONE state tasks from refile targets
(defun bh/verify-refile-target ()
  "Exclude todo keywords with a done state from refile targets"
  (not (member (nth 2 (org-heading-components)) org-done-keywords)))

(setq org-refile-target-verify-function 'bh/verify-refile-target)


;; init.el ends here
