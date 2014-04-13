(require 'package)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))
(package-initialize)

(defvar my-packages '(;; General
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
(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

;; fiplr
(global-set-key (kbd "C-x f") 'fiplr-find-file)
