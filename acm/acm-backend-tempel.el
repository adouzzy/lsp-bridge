;;; acm-backend-tempel.el -*- lexical-binding: t; -*-

(defcustom acm-enable-tempel t
  "Popup tempel completions when this option is turn on."
  :type 'boolean)

(defcustom acm-backend-tempel-candidates-number 2
  "Maximal number of yas candidate of menu."
  :type 'integer)

(defcustom acm-backend-tempel-insert-index 8
  "Insert index of yas candidate of menu."
  :type 'integer)
  
(defun acm-backend-tempel-candidates (keyword)
  (when (and acm-enable-tempel
             (ignore-errors (require 'tempel)))
    (let* ((candidates (list))
           (snippets (cl-loop for template in (tempel--templates) 
                              collect (format "%s" (car template))))
           (match-snippets (seq-filter (lambda (s) (acm-candidate-fuzzy-search keyword s)) snippets)))
         (dolist (snippet (cl-subseq match-snippets 0 (min (length match-snippets) acm-backend-tempel-candidates-number)))
           (add-to-list 'candidates (list :key snippet
                                          :icon "snippet"
                                          :label snippet
                                          :display-label snippet
                                          :annotation "Tempel"
                                          :backend "tempel")
                        t))
         (acm-candidate-sort-by-prefix keyword candidates))))
         
(defun acm-backend-tempel-candidate-expand (candidate-info bound-start)
  (delete-region bound-start (point))
  (tempel-insert (intern-soft (plist-get candidate-info :label))))

(defun acm-backend-tempel-candidate-fetch-doc (candidate)
  (acm-doc-show))

(defun acm-backend-tempel-candidate-doc (candidate)
  (let ((snippet
         (alist-get (intern-soft (plist-get candidate :label)) 
                    (tempel--templates))))            
    (mapconcat (lambda (s) (format "%s" s)) snippet " ")))
    
(provide 'acm-backend-tempel)

;;;acm-backend-tempel.el ends here

