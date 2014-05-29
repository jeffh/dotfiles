(require 'package)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
(package-initialize)

(defvar packages '(;; General
                   fiplr
                   auto-complete
                   zenburn-theme
                   ;; Clojure
                   starter-kit
                   starter-kit-lisp
                   starter-kit-bindings
                   starter-kit-eshell
                   clojure-mode
                   clojure-test-mode
                   cider
                   cider-nrepl
                   ;; Python
                   python-mode
                   django-mode
                   ;; JavaScript
                   js2-mode))

(when (not package-archive-contents)
  (package-refresh-contents))

(dolist (p packages)
  (when (and (not (package-installed-p p))
             (assoc p package-archive-contents))
    (package-install p)))

(defun package-list-unaccounted-packages ()
  "Like `package-list-packages', but shows only the packages that
  are installed and are not in `packages'.  Useful for
  cleaning out unwanted packages."
  (interactive)
  (package-show-package-list
   (remove-if-not (lambda (x) (and (not (memq x packages))
                                   (not (package-built-in-p x))
                                   (package-installed-p x)))
                                    (mapcar 'car package-archive-contents))))

;; fiplr
(global-set-key (kbd "C-x f") 'fiplr-find-file)

;; autosave
(setq auto-save-interval 5
      auto-save-timeout 5)

(defun full-auto-save ()
  (interactive)
  (save-excursion
    (dolist (buf (buffer-list))
      (set-buffer buf)
      (if (and (buffer-file-name) (buffer-modified-p))
          (basic-save-buffer)))))
(add-hook 'auto-save-hook 'full-auto-save)

;; delete the current file
(defun delete-this-buffer-and-file ()
  "Removes file connected to current buffer and kills buffer."
  (interactive)
  (let ((filename (buffer-file-name))
        (buffer (current-buffer))
        (name (buffer-name)))
    (if (not (and filename (file-exists-p filename)))
        (error "Buffer '%s' is not visiting a file!" name)
      (when (yes-or-no-p "Are you sure you want to remove this file? ")
        (delete-file filename)
        (kill-buffer buffer)
        (message "File '%s' successfully removed" filename)))))

(global-set-key (kbd "C-c k") 'delete-this-buffer-and-file)

;; themes & fonts
(add-to-list 'default-frame-alist
             '(font . "Monaco-14"))
(set-frame-parameter nil 'font "Monaco-14")

(load-theme 'zenburn t)
