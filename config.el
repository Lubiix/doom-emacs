;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 23 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "JetBrainsMono Nerd Font" :size 23))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;;(setq doom-theme 'doom-one)
(setq doom-theme 'doom-rose-pine)
;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
;;(setq display-line-numbers-type t)
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
(setq persp-auto-save-opt 0          ; save auto à la fermeture (protection crash)
      persp-auto-resume-time nil)    ; pas de resume auto → tu choisis au démarrage

(setq vterm-max-scrollback 100000)

(map! :leader
      :desc "Workspace 1" "&"  (cmd! (+workspace/switch-to 0))
      :desc "Workspace 2" "é"  (cmd! (+workspace/switch-to 1))
      :desc "Workspace 3" "\"" (cmd! (+workspace/switch-to 2))
      :desc "Workspace 4" "'"  (cmd! (+workspace/switch-to 3))
      :desc "Workspace 5" "("  (cmd! (+workspace/switch-to 4))
      :desc "Workspace 6" "-"  (cmd! (+workspace/switch-to 5)))

(setq scroll-margin 10                       ; équivalent scrolloff
      scroll-conservatively 101             ; scroll ligne par ligne, pas par page
      scroll-preserve-screen-position t     ; garde curseur à la même position visuelle
      hscroll-margin 10                      ; scrolloff horizontal
      hscroll-step 1)                       ; scroll horizontal ligne par ligne

;; Déplacer lignes en visual
(map! :v "J" (kbd ":m '>+1 RET gv=gv")
      :v "K" (kbd ":m '<-2 RET gv=gv")

      ;; Indent sans perdre la sélection
      :v "<" (kbd "<gv")
      :v ">" (kbd ">gv"))

;; Clipboard système + register blackhole (via leader SPC)
;; (map! :leader
;;       :nv :desc "Yank to clipboard"        "y" "\"+y"
;;       :nv :desc "Paste from clipboard"     "p" "\"+p"
;;       :v  :desc "Paste without overwrite"  "P" "\"_dP"
;;       :nv :desc "Delete (no register)"     "d" "\"_d"
;;       :n  :desc "Delete EOL (no register)" "D" "\"_D")

(add-hook 'prog-mode-hook #'hl-line-mode)
(add-hook 'text-mode-hook #'hl-line-mode)
(add-hook 'conf-mode-hook #'hl-line-mode)

(after! lsp-mode
  (lsp-register-client
   (make-lsp-client
    :new-connection (lsp-stdio-connection '("tailwindcss-language-server" "--stdio"))
    :major-modes '(tsx-ts-mode typescript-ts-mode web-mode css-mode scss-mode)
    :server-id 'tailwindcss
    :add-on? t
    :priority -1)))

(setq read-process-output-max (* 3 1024 1024)   ; 3MB au lieu de 4K par défaut
      gc-cons-threshold 100000000                ; 100MB GC threshold
      lsp-idle-delay 0.5
      lsp-log-io nil
      lsp-use-plists t)                          ; plists plus rapides que hash-tables

(setq warning-suppress-types '((lsp-mode)))

;;(setq lsp-log-io t)

;; org mode
(after! org-modern
  (setq org-modern-star ["◉" "○" "●" "✿" "✤" "✜" "◆"]
        org-modern-checkbox '((?X . "☑")
                              (?- . "☐")
                              (?\s . "☐"))
        org-modern-list '((?* . "•")
                          (?+ . "‣")
                          (?- . "–"))))
;; Démarrage full screen F11
(add-to-list 'default-frame-alist ' (fullscreen . fullboth))
