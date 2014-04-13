(require 'package)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
(package-initialize)

(defvar packages '(;; General
                   fiplr
                   ;; Clojure
                   starter-kit
                   starter-kit-lisp
                   starter-kit-bindings
                   starter-kit-eshell
                   clojure-mode
                   clojure-test-mode
                   cider
                   ;; Python
                   python-mode
                   django-mode
                   ;; JavaScript
                   js2-mode))

(when (not package-archive-contents)
  (package-refresh-contents))

(dolist (p packages)
  (when (and (not (package-installed-p p))
             (assoc pkg package-archive-contents))
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
