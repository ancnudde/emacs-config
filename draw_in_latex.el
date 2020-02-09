;;; draw_in_latex.el --- Allows to insert drawings in LaTeX files.

;; Author: Anthony Cnudde <anthonycnudde@live.be>
;; Feel free to use and modify this file as you need.


;;; Requirements:

;;    Program: kolourpaint.
;;    LaTeX packages: amsmath, graphicx, float.


;;; Commentary:

;; This packages is designed to work with LaTeX. It allows the user
;; to draw some stuff, and add it to the tex file.
;; The package works trough the "draw" command; draw calls kolourpaint,
;; where the user can draw whathever he wants. When it is done, the commands
;; adds the figure environments in the tex file, including the includegraphics
;; statement and the path of the drawing file.

;; The path of the file is set to the directory of the tex file. The name of
;; the drawing file is similar to the tex file in which is added a name for
;; the drawing that is asked to the user when command is called.


;;; Code:

(defun insert-file-name ()
  "Insert the full path file name into the current buffer."
  (file-name-base(buffer-file-name(window-buffer
				   (minibuffer-selected-window)))))

(defun insert-file-path ()
  "Insert the full path file name into the current buffer."
  (file-name-directory(buffer-file-name(window-buffer
		     (minibuffer-selected-window)))))


(defun draw_in_latex ()
  "Calls the painting program to let user draw, 
   and adds the figure in the latex document"
  (interactive)
  (setq doc_name (insert-file-name)  ;; Gets name of the LaTeX doc.
        doc_path (insert-file-path)  ;; Gets path of the LaTeX doc.
	;; Gets a name for the figure.
        fig (read-string "Enter figure name: ")
	;; Creates the name of the picture.
        drawing (concat doc_name "-" fig ".png"))
  ;; Replace "kolourpaint" if you want to change the program used.
  (shell-command (concat "kolourpaint " drawing))  ;; Calls kolourpaint.
  ;; Prints the LaTeX environment including path of the figure.
  (insert "\\begin{figure}[H]\n"
	  "  \\center\n"
	  "  \\includegraphics[width=10cm, height=10cm, keepaspectratio]
           {" doc_path drawing "}\n"
	   "\\end{figure}"))

(provide 'draw_in_latex)

;;; draw_in_latex.el ends here
