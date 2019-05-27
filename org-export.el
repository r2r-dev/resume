;; export index.org to index.html
(require 'org)
(require 'ox-html)
(defun export-index-to-html()
  (find-file "index.org")
  (org-html-export-to-html))
