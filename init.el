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

;; helm (included here because it doesn't seem to work with elpa)
(add-to-list 'load-path "/Users/andalucien/.emacs.d/helm")
(require 'helm-config)
(global-set-key (kbd "C-c h") 'helm-mini)
(require 'helm-ls-git)
(global-set-key (kbd "C-c l") 'helm-ls-git-ls)

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
        (:name sass-mode
               :type elpa
               :after (lambda ()
                        (setq scss-compile-at-save nil)
                        ))
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
(defun hashrocket() (interactive)
  (insert " => ")
)
(add-hook 'ruby-mode-hook  (lambda ()
            (define-key ruby-mode-map (kbd "C-#") 'string-interpolate)
            (define-key ruby-mode-map (kbd "C-c C-e") 'string-block)
            (define-key ruby-mode-map (kbd "C-=") 'hashrocket)
            (define-key ruby-mode-map (kbd "C-c d") 'ruby-debug)
            (define-key ruby-mode-map (kbd "C-c p") 'pry)
            (define-key ruby-mode-map (kbd "C-c ,s") 'rspec-verify-single)
            (define-key ruby-mode-map (kbd "C->") 'erb-tags)
            ))
(defun coffeerocket() (interactive)
  (insert " ->")
)
(defun debugger() (interactive)
  (insert "debugger")
)
(add-hook 'coffee-mode-hook  (lambda ()
            (define-key coffee-mode-map (kbd "C-#") 'string-interpolate)
            (define-key coffee-mode-map (kbd "C-=") 'hashrocket)
            (define-key coffee-mode-map (kbd "C--") 'coffeerocket)
            (define-key coffee-mode-map (kbd "C-c d") 'debugger)
            ))

(add-hook 'haml-mode-hook  (lambda ()
            (define-key haml-mode-map (kbd "C-#") 'string-interpolate)
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
            (define-key rhtml-mode-map (kbd "C-=") 'hashrocket)
            (define-key rhtml-mode-map [(control return)] 'html-line-break)
            (define-key rhtml-mode-map (kbd "C-c d") 'ruby-debug)
            (define-key rhtml-mode-map (kbd "C-c M-l") 'link-to-region)
            (define-key rhtml-mode-map (kbd "C-c M-l") 'link-to-region)
            (define-key rhtml-mode-map (kbd "C-c p") 'pry)
            (auto-fill-mode nil)
            ))

;; file extensions
(setq auto-mode-alist (cons '("\\.rake\\'" . ruby-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.yml\\'" . yaml-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("Gemfile" . yaml-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.hamlc\\'" . haml-mode) auto-mode-alist))


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

(defun beautify-json ()
  (interactive)
  (let ((b (if mark-active (min (point) (mark)) (point-min)))
        (e (if mark-active (max (point) (mark)) (point-max))))
    (shell-command-on-region b e
     "python -mjson.tool" (current-buffer) t)))

(fset 'velocity-startup
   [?\C-u ?\C-x ?\M-m ?w ?e ?b return ?\C-x ?q ?r ?s ?t return ?\C-u ?\C-x ?\M-m ?r ?s ?p ?e ?c return ?\C-x ?q ?b ?u ?n ?d ?l ?e ?  ?e ?x ?e ?c ?  ?s ?p ?o ?r ?k return ?\C-u ?\C-x ?\M-m ?c ?u ?c ?u ?m ?b ?e ?r return ?\C-x ?q ?b ?u ?n ?d ?l ?e ?  ?e ?x ?e ?c ?  ?s ?p ?o ?r ?k ?  ?c ?u ?c ?u ?m ?b ?e ?r return ?\C-u ?\C-x ?\M-m ?e ?v ?e ?r ?g ?r ?e ?e ?n return ?\C-x ?q ?e ?v ?e ?r ?g ?r ?e ?e ?n ?  ?s ?e ?r ?v ?e ?\C-u ?\C-x ?\M-m ?c ?o ?n ?s ?o ?l ?e return ?\C-x ?q ?r ?  ?c return ?\C-x ?\M-m ?\C-x ?3 ?\C-x ?g])
