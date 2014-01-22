(require 'cl)

;;Global editor directives
(setq debug-on-error nil)
(setq visible-bell nil)
(scroll-bar-mode -1)
(tool-bar-mode -1)

;;Package requirements
(require 'package)

;;(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))

(package-initialize)

(defvar my-packages
  '(magit
    markdown-mode
    mtgox
    request
    jenkins-watch
    yaml-mode
    flymake
    flymake-python-pyflakes
    virtualenv
    nose
    pydoc-info
    swbuff
    ;;font-lock
    autoinsert
    )
  "A list of packages to ensure are installed at launch.")

(defun my-packages-installed-p ()
  (cl-loop for p in my-packages
        when (not (package-installed-p p)) do (cl-return nil)
        finally (cl-return t)))

(unless (my-packages-installed-p)
  ;; check for new packages (package versions)
  (package-refresh-contents)
  ;; install the missing packages
  (dolist (p my-packages)
    (when (not (package-installed-p p))
      (package-install p))))

;; Not available on repos
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(add-to-list 'load-path "~/.emacs.d/")

(require 'flymake-node-jshint)
(require 'font-lock)
(require 'pydoc-info)
(require 'jenkins-watch)

;; Custom directives
(setq default-major-mode 'text-mode)
(setq tab-width 4)

(setq user-mail-address "niedbalski@gmail.com")
(setq user-full-name "Jorge Niedbalski R.")

;; be nice with X clipboard
(setq x-select-enable-clipboard t)

;; use Control+g fot goto-line
(global-set-key [(control g)] 'goto-line)

;; Comment or uncomment region
(defun comment-or-uncomment-region-or-line ()
    "Comments or uncomments the region or the current line if there's no active region."
    (interactive)
    (let (beg end)
        (if (region-active-p)
            (setq beg (region-beginning) end (region-end))
            (setq beg (line-beginning-position) end (line-end-position)))
        (comment-or-uncomment-region beg end)
        (next-line)))

(global-set-key (kbd "C-c C-c") 'comment-or-uncomment-region-or-line)

;;AUTO-FILL-MODE
(auto-fill-mode 1)
(setq fill-column 79)

;; Some python hooks
(require 'flymake-python-pyflakes)

(setq flymake-python-pyflakes-executable "flake8")
(add-hook 'python-mode-hook 'flymake-python-pyflakes-load)

;; Speedbar
;; (sr-speedbar-open)
;; (setq speedbar-use-images nil)
;; (add-hook 'python-mode-hook '(lambda () (highlight-lines-matching-regexp
;;                                       ".\\{81\\}" 'hi-yellow)))

(add-hook 'js-mode-hook (lambda () (flymake-mode 1)))

;; iswitch enabled
(iswitchb-mode 1)
(setq iswitchb-buffer-ignore '("^ " "*buffer"))
(setq iswitchb-buffer-ignore '("^\\*"))
(setq iswitchb-default-method 'samewindow)

;; enable menubar and tool bar
;;(menu-bar-mode 1)
;;(tool-bar-mode 1)

;; swbuff with ctrl + tab
(global-set-key [(control tab)]  'swbuff-switch-to-next-buffer)
(global-set-key (kbd "<C-s-iso-lefttab>") 'swbuff-switch-to-previous-buffer)

;; turn on font-lock mode
(global-font-lock-mode t)

;; simple cut, copy, paste
;;cut the entire buffer
;; f6 copy whole buffer
(defun fm-copy-whole-buffer ()
  "copy the whole buffer into the kill ring"
  (interactive)
  (mark-whole-buffer)
  (copy-region-as-kill-nomark(region-beginning) (region-end)))

;;
(global-set-key [f2] 'clipboard-kill-region)
(global-set-key [f3] 'clipboard-kill-ring-save)
(global-set-key [f4] 'clipboard-yank)
(global-set-key [f6] 'fm-copy-whole-buffer)

(global-set-key [f10] 'flymake-goto-prev-error)
(global-set-key [f11] 'flymake-goto-next-error)


;; beginning of the buffer / end
(global-set-key (kbd "C-x a") 'beginning-of-buffer)
(global-set-key (kbd "C-x e") 'end-of-buffer)

(global-set-key [end] 'end-of-line)
(global-set-key [home] 'beginning-of-line)

;;touche del et suppr
(global-set-key [delete] 'delete-char)

;;(dysplay question in 'y/n' instead of 'yes/no')
(fset 'yes-or-no-p 'y-or-n-p)

;;; prevent extraneous tabs
(setq-default indent-tabs-mode nil)

;; line number disable with c-f5
(autoload 'linum-mode "linum" "toggle line numbers on/off" t)
(global-linum-mode 0)
(setq linum-format "%4d \u2502 ")
(global-set-key (kbd "C-<f5>") 'linum-mode)

;; enable underline
(global-hl-line-mode 1)

(set-face-background 'highlight "#222")
(set-face-foreground 'highlight nil)
(set-face-underline-p 'highlight t)

(put 'downcase-region 'disabled nil)
(put 'set-goal-column 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'upcase-region 'disabled nil)

;; move between windows
(defun select-next-window ()
  "switch to the next window"
  (interactive)
  (select-window (next-window)))

(defun select-previous-window ()
  "Switch to the previous window"
  (interactive)
  (select-window (previous-window)))

(global-set-key (kbd "M-<right>") 'select-next-window)
(global-set-key (kbd "M-<left>")  'select-previous-window)

(defun beautify-json ()
  (interactive)
  (let ((b (if mark-active (min (point) (mark)) (point-min)))
        (e (if mark-active (max (point) (mark)) (point-max))))
    (shell-command-on-region b e
                             "python -mjson.tool" (current-buffer) t)))

(setq c-basic-offset 4)
(setq c-indent-level 4)

(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yaml$" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.hbs$" . html-mode))

; autoinsert mode ( templates )
(auto-insert-mode)  ;;; Adds hook to find-files-hook
(setq auto-insert-query nil)
(setq auto-insert-directory "~/.emacs.d/templates/")
(define-auto-insert "\.py" "template.py")

(defun add-py-debug ()
        "add debug code and move line down"
            (interactive)
                (move-beginning-of-line 1)
                    (insert "from nose.tools import set_trace; set_trace()\n"))

(local-set-key (kbd "f5") 'add-py-debug)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#242424" "#E5786D" "#95E454" "#CAE682" "#8AC6F2" "#333366" "#CCAA8F" "#F6F3E8"])
 '(custom-enabled-themes (quote (django)))
 '(custom-safe-themes
   (quote
    ("08eb36b2ce2dcc5aceaed5e0be492661990dcc860d9148b748c008ed952cf249" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default)))
 '(inhibit-startup-screen t)
 '(safe-local-variable-values
   (quote
    ((eval jenkins-watch-start)
     (eval setq jenkins-api-url "https://jenkins.nimbic.com/view/nView/job/nview-tests/api/xml")))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


(add-hook 'find-file-hook 'flymake-find-file-hook)
(add-hook 'before-save-hook 'delete-trailing-whitespace)

(when (load "flymake" t)
  (defun flymake-pyflakes-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
               'flymake-create-temp-inplace))
       (local-file (file-relative-name
            temp-file
            (file-name-directory buffer-file-name))))
      (list "pep8"  (list local-file))))
  (add-to-list 'flymake-allowed-file-name-masks
             '("\\.py\\'" flymake-pyflakes-init)))

;;(setq jenkins-api-url 'https://jenkins.nimbic.com/view/nView/job/nview-tests/api/xml)
;;           (eval . (jenkins-watch-start))


;; Evaluate dir-locals
(setq nwebstack-path "/home/aktive/nwebstack.git")

(add-hook
 'before-hack-local-variables-hook'
 (lambda ()
   (when buffer-file-name
     ( let ((dir (file-name-directory buffer-file-name)))
       (if (string-equal dir nwebstack-path)
           (progn
             (setq enable-local-eval t)
             (setq enable-local-variables t))
           (progn
             (setq enable-local-eval nil)
             (setq enable-local-variables nil)))))))


;;Git handling of.
(require 'magit)

(global-set-key (kbd "M-s") 'magit-status)
(add-hook 'magit-mode-hook
          '(lambda()
             (progn
               (local-set-key (kbd "c") 'magit-commit)
               (local-set-key (kbd "d") 'magit-diff-working-tree)))))


(require 'mtgox)
(mtgox-mode 1)
