;; emacs configuration
(push "/usr/local/bin" exec-path)

; set initial frame size
(setq default-frame-alist
      (append default-frame-alist
              '(
                (width . 160) (height . 40)
                )))

(setq make-backup-files nil)
(setq auto-save-default nil)
(setq-default tab-width 2)
(setq-default indent-tabs-mode nil)
(setq inhibit-startup-message t)
(setq mac-command-modifier 'meta)

(fset 'yes-or-no-p 'y-or-n-p)
(delete-selection-mode t)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(blink-cursor-mode t)
(show-paren-mode t)
(column-number-mode t)
(set-fringe-style -1)
(tooltip-mode -1)

;; package management: el-get
(require 'package)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))
(package-initialize)
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
(require 'el-get)

(setq el-get-sources
      '((:name coffee-mode :type elpa)
        (:name css-mode :type elpa)
        (:name haml-mode :type elpa)
        (:name inf-ruby :type elpa)
        (:name feature-mode :type elpa)
        (:name magit :type elpa
               :after (lambda ()
                        (global-set-key (kbd "C-x g") 'magit-status)
                        ))
        (:name rhtml
               :type git
               :url "https://github.com/eschulte/rhtml.git"
               :features rhtml-mode)
        (:name rspec-mode
               :type git
               :url "git@github.com:mforsyth/rspec-mode.git"
               :features rspec-mode
               :after (lambda ()
                        (setq rspec-use-rake-flag nil)
                        (setq rspec-use-rvm t)
                        (setq rspec-spec-command "rspec")
                        ))
        (:name ruby-mode
               :type elpa
               :load "ruby-mode.el")
        (:name ruby-compilation :type elpa)
        (:name rvm
               :type git
               :url "http://github.com/djwhitt/rvm.el.git"
               :load "rvm.el"
               :compile ("rvm.el")
               :after (lambda() (rvm-use-default)))
        (:name sass-mode :type elpa)
        (:name textmate
               :type git
               :url "git://github.com/defunkt/textmate.el"
               :load "textmate.el")
        (:name yaml-mode
               :type git
               :url "http://github.com/yoshiki/yaml-mode.git"
               :features yaml-mode)))
(el-get 'sync)
(require 'vc-git)


; mini ruby snippets
(defun ruby-debug() (interactive)
  (insert "debugger\nfoo = 'bar'")
  (indent-for-tab-command)
  )
(defun pry() (interactive)
  (insert "binding.pry\n")
  (indent-for-tab-command)
  (previous-line)
  (indent-for-tab-command)
  )
(defun string-interpolate() (interactive)
  (insert "#{}")
  (backward-char 1)
  )
(defun string-block() (interactive)
  (insert "<<-END\n\nEND\n")
  (backward-char 5)
)
(defun hash-boundary() (interactive)
  (insert " => ")
)
(add-hook 'ruby-mode-hook  (lambda ()
            (define-key ruby-mode-map (kbd "C-#") 'string-interpolate)
            (define-key ruby-mode-map (kbd "C-c C-e") 'string-block)
            (define-key ruby-mode-map (kbd "C-=") 'hash-boundary)
            (define-key ruby-mode-map (kbd "C-c d") 'ruby-debug)
            (define-key ruby-mode-map (kbd "C-c p") 'pry)
            (define-key ruby-mode-map (kbd "C-c ,s") 'rspec-verify-single)
            ))

; rhtml-mode
(add-to-list 'load-path "~/.emacs.d/vendor/rhtml/")
(require 'rhtml-mode)
(defun erb-tags() (interactive)
  (insert "<% %>")
  (backward-char 3)
  )
(defun html-line-break() (interactive)
  (indent-for-tab-command)
  (insert "<br/>\n")
  )
(defun link-to-region (start end)
  (interactive "r")
  (goto-char start)
  (insert "<%= link_to '")
  (goto-char end)
  (forward-word)
  (insert "', '' %>")
  (backward-char 4)
  )
(add-hook 'rhtml-mode-hook
          (lambda ()
            (define-key rhtml-mode-map (kbd "C->") 'erb-tags)
            (define-key rhtml-mode-map (kbd "C-#") 'string-interpolate)
            (define-key rhtml-mode-map (kbd "C-=") 'hash-boundary)
            (define-key rhtml-mode-map [(control return)] 'html-line-break)
            (define-key rhtml-mode-map (kbd "C-c d") 'ruby-debug)
            (define-key rhtml-mode-map (kbd "C-c M-l") 'link-to-region)
            (define-key rhtml-mode-map (kbd "C-c M-l") 'link-to-region)
            (define-key rhtml-mode-map (kbd "C-c p") 'pry)
            (auto-fill-mode)
            ))

;; file extensions
(setq auto-mode-alist (cons '("\\.rake\\'" . ruby-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.yml\\'" . yaml-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("Gemfile" . yaml-mode) auto-mode-alist))


;; themes
(set-frame-font "Menlo-14")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("5e79d0908abcd7654e4cc0865a4ee2f5854e9ea0d7353d69d04a704443769133" "9640ea843da3baee6fd9f6e249acc3edbc396b25e30b204c1787e7b6f26ceee4" "d6a00ef5e53adf9b6fe417d2b4404895f26210c52bb8716971be106550cea257" default))))
(load-theme 'zenburn)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(eval-after-load 'magit
  '(progn
     (set-face-foreground 'magit-diff-add "pale green")
     (set-face-foreground 'magit-diff-del "light coral")
     (set-face-background 'magit-item-highlight "grey30")
     (set-face-attribute 'magit-item-highlight nil :underline 0)
     ))

;; trailing whitespace
(setq-default show-trailing-whitespace t)

; shortcut to open this file
(defun open-emacs-profile () (interactive)
  (find-file "~/.emacs.d/init.el")
  )

;; javascript mode config
(setq js-indent-level 2)

;; global keys
(global-set-key (kbd "C-c mep") 'open-emacs-profile)
(global-set-key (kbd "C-c s") 'vc-git-grep)
(global-set-key (kbd "C-c r") 'replace-regexp)
(global-set-key (kbd "C-x M-m") 'shell)
(global-set-key (kbd "C-x m") 'eshell)
(global-set-key (kbd "C-x m") 'eshell)
(global-set-key (kbd "C-c w s") 'delete-trailing-whitespace)

(setq feature-cucumber-command "bash --login -c \"bundle exec rake cucumber CUCUMBER_OPTS=\\\"{options}\\\" FEATURE=\\\"{feature}\\\"\"")
