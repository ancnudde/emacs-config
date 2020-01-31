;; init.el --- Emacs configuration

;; INSTALL PACKAGES
;; --------------------------------------

(require 'package)

;; Internet repositories for new packages.
(setq package-archives '(("org"       . "http://orgmode.org/elpa/")
                         ("gnu"       . "http://elpa.gnu.org/packages/")
                         ("melpa"     . "http://melpa.org/packages/")
                         ("melpa-stable" . "http://stable.melpa.org/packages/")))

 

(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))
1
(defvar myPackages
  '(better-defaults
    material-theme
    autopair
    ess
    elpy
    py-autopep8
    jedi
    flycheck
    company
    polymode
    poly-R
    yasnippet-snippets
    pdf-tools
    auctex
    irony
    company-irony))

(mapc #'(lambda (package)
    (unless (package-installed-p package)
      (package-install package)))
      myPackages)

;; BASIC CUSTOMIZATION
;; --------------------------------------

(setq inhibit-startup-message t) ;; hide the startup message
(load-theme 'material t) ;; load material theme

;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(TeX-view-program-list (quote ((output-pdf "PDF Tools"))) t)
 '(ansi-color-faces-vector
   [default bold shadow italic underline bold bold-italic bold])
 '(ansi-color-names-vector
   (vector "#212121" "#B71C1C" "#558b2f" "#FFA000" "#2196f3" "#4527A0" "#00796b" "#FAFAFA"))
 '(custom-enabled-themes (quote (material)))
 '(custom-safe-themes
   (quote
    ("a24c5b3c12d147da6cef80938dca1223b7c7f70f2f382b26308eba014dc4833a" "732b807b0543855541743429c9979ebfb363e27ec91e82f463c91e68c772f6e3" default)))
 '(elpy-modules
   (quote
    (elpy-module-company elpy-module-flymake elpy-module-pyvenv elpy-module-highlight-indentation elpy-module-yasnippet elpy-module-django elpy-module-sane-defaults)))
 '(fci-rule-color "#ECEFF1")
 '(hl-sexp-background-color "#efebe9")
 '(initial-frame-alist (quote ((fullscreen . maximized))))
 '(package-selected-packages
   (quote
    (company-irony-c-headers company-irony imenu-list swiper auctex helm neotree yasnippet-snippets yasnippet company-c-headers fill-column-indicator sr-speedbar company-jedi ess poly-R autopair flycheck py-autopep8 elpy pdf-tools material-theme better-defaults)))
 '(vc-annotate-background nil)
 '(vc-annotate-color-map
   (quote
    ((20 . "#B71C1C")
     (40 . "#FF5722")
     (60 . "#FFA000")
     (80 . "#558b2f")
     (100 . "#00796b")
     (120 . "#2196f3")
     (140 . "#4527A0")
     (160 . "#B71C1C")
     (180 . "#FF5722")
     (200 . "#FFA000")
     (220 . "#558b2f")
     (240 . "#00796b")
     (260 . "#2196f3")
     (280 . "#4527A0")
     (300 . "#B71C1C")
     (320 . "#FF5722")
     (340 . "#FFA000")
     (360 . "#558b2f"))))
 '(vc-annotate-very-old-color nil))


(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(preview-face ((t nil)))
 '(preview-reference-face ((t nil))))

;; starts emacs in full screen

;; Show lines numbers for programming modes.
(add-hook 'prog-mode-hook 'linum-mode)

(elpy-enable)
(setq elpy-rpc-python-command "python3")
(setq python-shell-interpreter "python3")
(setq pyvenv-activate "/home/anthony/anaconda3/envs/myenv")

(autopair-global-mode) ;; to enable in all buffers

(add-hook 'elpy-mode-hook 'flycheck-mode)

(add-hook 'ess-mode-hook 'auto-complete-mode)

;; Forces the messages to 0, and kills the *Messages* buffer - thus disabling it on startup.
(setq-default message-log-max nil)
(kill-buffer "*Messages*")

;; Disabled *Completions*
(add-hook 'minibuffer-exit-hook 
      '(lambda ()
         (let ((buffer "*Completions*"))
           (and (get-buffer buffer)
            (kill-buffer buffer)))))

;; Shortcuts
(global-set-key (kbd "M-0") 'indent-rigidly) ;; Indentation


(defun my-c++-mode-hook ()
  (irony-mode))
(add-hook 'c++-mode-hook 'my-c++-mode-hook)
(require 'company)
(add-hook 'after-init-hook 'global-company-mode)

(setq-default
 whitespace-line-column 80
 whitespace-style       '(face lines-tail))
(add-hook 'prog-mode-hook #'whitespace-mode)

(setq fci-rule-column 80)
(setq fci-rule-width 3)

(require 'company)
(add-hook 'global-init-hook 'global-company-mode)
(add-to-list 'company-backends 'company-c-headers)

(yas-global-mode 1)
(put 'erase-buffer 'disabled nil)
(put 'upcase-region 'disabled nil)

(eval-after-load "preview"
  '(add-to-list 'preview-default-preamble "\\PreviewEnvironment{tikzpicture}" t)
  )


;;Latex real-time preview

;; to use pdfview with auctex
(pdf-tools-install)
(setq TeX-view-program-selection '((output-pdf "PDF Tools"))
    TeX-view-program-list '(("PDF Tools" TeX-pdf-tools-sync-view))
    TeX-source-correlate-start-server t) ;; not sure if last line is neccessary


;;Eliminates the necessity for the save command before compilation is completed
(setq TeX-save-query nil)

;;Function that combines two commands 1. revert pdfoutput buffer 2. pdf-outline
(defun my-TeX-revert-document-buffer (file)
  (TeX-revert-document-buffer file)
  (pdf-outline))

;; Add custom function to the TeX compilation hook
(add-hook 'TeX-after-compilation-finished-functions
	  #'TeX-revert-document-buffer)

;; Define the modes/packages you need
(require 'company)
(require 'irony)
(require 'company-c-headers)
;; Enable company mode globally 
(add-hook 'after-init-hook 'global-company-mode)

;; Here I define a function so it can be called anytime I want to load it
(defun irony-comp-setup-basic()
;; A function to add path to company-c-headers
  (defun company-c-headers-includes ()
;; You just need to modified the path inside the quote to your header files path
    (add-to-list 'company-c-headers-path-system "$ROOTSYS/include")
    )
;; Now call this function so it add your path to company-c-header-path-system
  (company-c-headers-includes)
  ;; Irony-mode configuration
  (add-hook 'c++-mode-hook 'irony-mode)
  (add-hook 'c-mode-hook 'irony-mode)
  (add-hook 'objc-mode-hook 'irony-mode)

  ;; replace the `completion-at-point' and `complete-symbol' bindings in
  ;; irony-mode's buffers by irony-mode's function
  (defun my-irony-mode-hook ()
    (define-key irony-mode-map [remap completion-at-point]
      'irony-completion-at-point-async)
    (define-key irony-mode-map [remap complete-symbol]
      'irony-completion-at-point-async))
  (add-hook 'irony-mode-hook 'my-irony-mode-hook)
  ;; This customize some backends to the company-backends
  ;; I took it from my friend's code
  (custom-set-variables
   '(company-backends (quote (company-irony company-elisp
                                            company-bbdb company-nxml
                                            company-css company-eclim
                                            company-semantic company-clang
                                            company-xcode company-ropemacs
                                            company-cmake company-capf
                                            (company-dabbrev-code
                                             company-gtags
                                             company-etags
                                             company-keywords)
                                            company-oddmuse
                                            company-files
                                            company-dabbrev))))
(custom-set-faces)

;; This add your company-c-headers to company-backends
  (add-to-list 'company-backends 'company-c-headers)

;; Default config for company-irony mode
  (eval-after-load 'company
    '(add-to-list
      'company-backends 'company-irony))

;; For irony mode I think
  (add-hook 'irony-mode-hook 'company-irony-setup-begin-commands)
)
;; Now call this function to active it
(irony-comp-setup-basic)

(setq-default c-basic-offset 4)

(setq display-buffer-alist '((".*\\*shell\\*.*" display-buffer-same-window (nil))))

