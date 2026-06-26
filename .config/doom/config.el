;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; User Information
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (setq user-full-name "Your Name")
;; (setq user-mail-address "you@example.com")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Theme
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq doom-theme 'doom-tokyo-night)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Fonts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq doom-font
      (font-spec
       :family "JetBrainsMono Nerd Font"
       :size 16
       :weight 'bold))

(setq doom-variable-pitch-font
      (font-spec
       :family "Noto Sans"
       :size 16))

(setq doom-big-font
      (font-spec
       :family "JetBrainsMono Nerd Font"
       :size 24
       :weight 'medium))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; UI
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq display-line-numbers-type 'relative)

(global-hl-line-mode 1)

(show-paren-mode 1)

(setq-default line-spacing 0.15)


(setq frame-resize-pixelwise t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Clipboard
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq select-enable-clipboard t
      select-enable-primary t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Editing
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq use-short-answers t)

(global-auto-revert-mode 1)

(setq vc-follow-symlinks t)

(setq indent-tabs-mode nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Evil
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Keep clipboard when pasting over a visual selection
(setq evil-kill-on-visual-paste nil)

(after! evil-goggles
  (evil-goggles-mode 1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Org
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq org-directory "~/org/")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Vundo
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(after! vundo
  (setq vundo-glyph-alist vundo-unicode-symbols
        vundo-compact-display t))

(map! :leader
      :desc "Visual Undo"
      "u" #'vundo)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Convenience Keybindings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(map! :leader
      :desc "Open Terminal" "o t" #'vterm

      :desc "Reload Doom" "h r r" #'doom/reload

      :desc "Open Config" "f c"
      (cmd! (find-file "~/.config/doom/config.el")))

;; Delete without copying

(after! evil
  (defun my/evil-delete-black-hole (orig beg end &optional type register yank-handler)
    "Send all delete operations to the black-hole register by default."
    (funcall orig beg end type (or register ?_) yank-handler))
  (advice-add #'evil-delete :around #'my/evil-delete-black-hole))

;; corfu
(after! corfu
  (setq corfu-auto t
        corfu-auto-delay 0.15
        corfu-auto-prefix 1
        corfu-preview-current t
        corfu-cycle t)
  (corfu-popupinfo-mode 1))

;; rember cursor postion
(save-place-mode 1)

;; better navigation
(map!
 :n "C-h" #'evil-window-left
 :n "C-j" #'evil-window-down
 :n "C-k" #'evil-window-up
 :n "C-l" #'evil-window-right)

;; better undo
(setq evil-want-fine-undo t)
;; inline error
(use-package! sideline
  :hook (flymake-mode . sideline-mode)
  :config
  (setq sideline-backends-right '(sideline-flymake)
        sideline-flymake-display-mode 'point))
