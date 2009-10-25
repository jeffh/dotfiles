;; where emacs files are
(defvar emacsfiles (concat (getenv "HOME") "/.emacs.d"))

;; I only have emacs for windows, so this is win specific
(cd "C:/Users/Jeff/")

;; set win32-emacs valuds
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(w32shell-cygwin-bin "c:\\cygwin\\bin")
 '(w32shell-shell (quote cygwin)))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )

;;;;;; KEY BINDINGS ;;;;;;;
;; compile=f6; debug=f5
(global-set-key (kbd "<f6>") 'compile)
(global-set-key (kbd "<f5>") 'debug)
;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; max soft width
(setq-default fill-column 72)
(setq auto-fill-mode 1)
;; line numbers
(line-number-mode 1)
(column-number-mode 1)

;; color-themes plugin
(add-to-list 'load-path (concat emacsfiles "/color-theme-6.6.0"))
(require 'color-theme)
(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
     (color-theme-hober)
     (color-theme-twilight)))

;; Duplicate line feature: like vim yyp command set
(defun duplicate()
  "Duplicates current line."
  (interactive)
  (let ((beg (line-beginning-position))
	(end (line-end-position)))
    (copy-region-as-kill beg end)
    (beginning-of-line)
    (forward-line 1)
    (yank)
    (newline)
    (forward-line -1)))
;; bind it to C-q
(global-set-key (kbd "C-q") 'duplicate)

;; no splash
(setq inhibit-splash-screen t)

;; include all files recursively
(if (fboundp 'normal-top-level-add-subdirs-to-load-path)
    (let* ((my-lisp-dir emacsfiles)
	   (default-directory my-lisp-dir))
      (setq load-path (cons my-lisp-dir load-path))
      (normal-top-level-add-subdirs-to-load-path)))

;; store autosave files in one location
(defvar autosave-dir (concat emacsfiles "/autosaves"))
(make-directory autosave-dir t)
(defun make-auto-save-file-name ()
  (concat autosave-dir
	  (if buffer-file-name
	      (concat "#" (file-name-nondirectory buffer-file-name) "#")
	    (expand-file-name
	     (concat "#%" (buffer-name) "#")))))

;; store backup files in one location
(defvar backup-dir (concat emacsfiles "/backups"))
(make-directory backup-dir t)
(setq backup-directory-alist (list (cons "." backup-dir)))

;; line numbers
(require 'linum)
(global-linum-mode 1)

;; remove menubar, toolbar
;(menu-bar-mode -1)
(tool-bar-mode -1)
(setq ring-bell-function 'ignore) ; remove annoying bell

;; make scripts executable on save
(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)

;; change the title bar to ~/file-directory if the current buffer is a
;; real file or buffer name if it is just a buffer
(setq frame-title-format
      '(:eval
	(if buffer-file-name
	    (replace-regexp-in-string
	     (getenv "HOME") "~"
	     (file-name-directory buffer-file-name))
	  (buffer-name))))

;; preserve the owner & group of file you're editing
(setq backup-by-copying-when-mismatch t)

;; Drive out mouse when it's too near to the cursor
(mouse-avoidance-mode 'animate)

;; recent files on startup
(recentf-mode 1)
(setq recentf-max-saved-items 1200)

;; indent if we're at the end of a word or tab otherwise
;; replaced this function with nxhtml's tabkey2
(global-set-key [(tab)] 'smart-tab)
(defun smart-tab ()
  "This smart tab is minibuffer compliant: it acts as usual in
    the minibuffer. Else, if mark is active, indents region. Else if
    point is at the end of a symbol, expands it. Else indents the
    current line."
  (interactive)
  (if (minibufferp)
      (unless (minibuffer-complete)
        (dabbrev-expand nil))
    (if mark-active
        (indent-region (region-beginning)
                       (region-end))
      (if (looking-at "\\_>")
          (dabbrev-expand nil)
        (indent-for-tab-command)))))

;;;;; PLUGINS ;;;;;
;; Uniquify ;;
;; for buffers with same filenames (appends parent directory)
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

;;;;; LANGUAGE MODES ;;;;;
;; clojure-mode ;;
(autoload 'clojure-mode "clojure-mode" "Clojure Mode." t)
(add-to-list 'auto-mode-alist '("\\.clj" . clojure-mode))

;; Python ;;
;; python-mode
(autoload 'python-mode "python-mode" "Python Mode." t)
;(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
;(add-to-list 'interpreter-mode-alist '("python" . python-mode))

(add-hook 'python-mode-hook
	  (lambda ()
	    (set (make-variable-buffer-local 'beginning-of-defun-function)
		 'py-beginning-of-def-or-class)
	    (setq outline-regexp "def\\|class ")))

;; pymacs (python for emacs)
(defvar python-installs (concat emacsfiles "/python-installs/"))
(autoload 'pymacs-apply "pymacs")
(autoload 'pymacs-call "pymacs")
(autoload 'pymacs-eval "pymacs" nil t)
(autoload 'pymacs-exec "pymacs" nil t)
(autoload 'pymacs-load "pymacs" nil t)
(eval-after-load "pymacs"
  '(progn (add-to-list 'pymacs-load-path
		       (concat python-installs "ropemacs-0.6c2"))
	  (add-to-list 'pymacs-load-path
		       (concat python-installs "rope-0.9.2"))))

;; ropemacs (python refactorer -- in python)
;; automatically save project python buffers before refactoring
;;(setq ropemacs-confirm-saving 'nil)
;; load on startup -- to load for dynamic loading
;;(pymacs-load "ropemacs" "rope-")
;; dynamically load ropemacs: only when we're in python-mode
;(defun load-ropemacs ()
;  "Enable ropemacs only when python mode is in"
;  (when (memq major-mode '(python-mode))
;    (pymacs-load "ropemacs" "rope-")))
;(add-hook 'find-file-hooks 'loadn-ropemacs)

;; html-mode (nxhtml) ;;
(load "nxhtml/autostart.el")

;; javascript-mode (js2Mode) ;;
(autoload 'js2-mode "js2" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

;; django-mode ;;
(load "django-mode.el")
