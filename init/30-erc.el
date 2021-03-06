(make-variable-buffer-local 'erc-fill-column)
(add-hook 'window-configuration-change-hook 
	  '(lambda ()
	     (save-excursion
	       (walk-windows
		(lambda (w)
		  (let ((buffer (window-buffer w)))
		    (set-buffer buffer)
		    (when (eq major-mode 'erc-mode)
		      (setq erc-fill-column (- (window-width w) 2)))))))))
(add-hook 'erc-mode-hook 'buffer-face-mode-variable)

(defun gnu-tls-available-p ()
  nil)

(setq tls-program '("openssl s_client -connect %h:%p -no_ssl2 -ign_eof"))

(defun erc-cmd-OPALL (&rest ignore)
  (let ((line "") (count-line-names 0))
    (maphash
     (lambda (user data)
       (let ((nick (erc-server-user-nickname (car data))))
	 (unless (or
		  (string= nick "oonbotti2")
		  (erc-channel-user-op (cdr data)))
	   (setq line (concat line (concat nick " ")))
	   (incf count-line-names)))
       (when (= count-line-names 4)
	 (erc-cmd-SAY (concat "#op " line))
	 (print line (current-buffer))
	 (setq line "")
	 (setq count-line-names 0)))
     erc-channel-users)
    (when (not (zerop count-line-names))
      (erc-cmd-SAY (concat "#op " line))
      (print line (current-buffer)))))

(defun erc-cmd-DEOPALL (&rest ignore)
  (let ((line "") (count-line-names 0))
    (maphash
     (lambda (user data)
       (let ((nick (erc-server-user-nickname (car data))))
	 (unless (or
		  (string= nick "oonbotti2")
		  (not (erc-channel-user-op (cdr data))))
	   (setq line (concat line (concat nick " ")))
	   (incf count-line-names)))
       (when (= count-line-names 4)
	 (erc-cmd-SAY (concat "#deop " line))
	 (print line (current-buffer))
	 (setq line "")
	 (setq count-line-names 0)))
     erc-channel-users)
     (unless (zerop count-line-names)
       (erc-cmd-SAY (concat "#deop " line))
       (print line (current-buffer)))))
