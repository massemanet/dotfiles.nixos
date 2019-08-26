;;; masserlang --- Summary
;;; Commentary:
;;; masse's erlang setup
;;; Code:

(require 'align)
(require 'erlang-start)
(require 'company)
;;(require 'company-distel)

(defun my-shell-mode ()
  "My erlang shell mode bindings."
  (setq comint-history-isearch 'dwim
        comint-input-ignoredups t)
  (local-set-key (kbd "C-n") 'comint-next-input)
  (local-set-key (kbd "C-p") 'comint-previous-input))
(add-hook 'erlang-shell-mode-hook 'my-shell-mode)

;;(distel-setup)
;;(add-to-list 'company-backends 'company-distel-modules)
(setq company-require-match nil)
(setq company-lighter nil)

(set-variable 'erlang-electric-commands nil)
(setq safe-local-variable-values
      (quote ((erlang-indent-level . 4)
              (erlang-indent-level . 2))))

(defun my-erlang-mode-hook ()
  "We want company mode and flycheck."
  (setq
   flycheck-erlang-executable "/home/masse/otp/bin/erlc"
   flycheck-erlang-include-path (append
                                 (file-expand-wildcards
                                  (concat
                                   (flycheck-rebar3-project-root)
                                   "_build/*/lib/*/include"))
                                 (file-expand-wildcards
                                  (concat
                                   (flycheck-rebar3-project-root)
                                   "_checkouts/*/include")))
   flycheck-erlang-library-path (append
                                 (file-expand-wildcards
                                  (concat
                                   (flycheck-rebar3-project-root)
                                   "_build/*/lib/*/ebin"))
                                 (file-expand-wildcards
                                  (concat
                                   (flycheck-rebar3-project-root)
                                   "_checkouts/*/ebin"))))
  (company-mode t)
  (unless (null buffer-file-name)
    (make-local-variable 'compile-command)
    (setq compile-command
          (cond ((file-exists-p "../rebar.config")
                 "cd .. && rebar3 compile")
                ((file-exists-p "Makefile")
                 "make -k")
                ((file-exists-p "../Makefile")
                 "make -kC..")
                (t (concat
                    "erlc "
                    (if (file-exists-p "../ebin") "-o ../ebin " "")
                    (if (file-exists-p "../include") "-I ../include " "")
                    "+debug_info -W "
                    buffer-file-name))))))

(add-hook 'erlang-mode-hook 'my-erlang-mode-hook)

(defun my-erlang-new-file-hook ()
  "Insert my very own erlang file header."
  (interactive)
  (insert "%% -*- mode: erlang; erlang-indent-level: 4 -*-\n")
  (insert (concat "-module(" (erlang-get-module-from-file-name) ").\n\n"))
  (insert (concat "-export([]).\n\n")))

(add-hook 'erlang-new-file-hook 'my-erlang-new-file-hook)

(provide 'masserlang)

;;; masserlang.el ends here
