(use-modules (haunt asset)
             (haunt builder blog)
             (haunt builder atom)
             (haunt builder assets)
             (haunt reader commonmark)
             (haunt site)
             (haunt post)
             (pages index)
	           (theme))

(define %blog-collection
  `(("Recent Posts" "/blog/index.html" ,posts/reverse-chronological)))

(site #:title "Guilherme Torquato"
      #:domain "trqt.github.io"
      #:default-metadata
      '((author . "me")
        (email  . "me@uol.br"))
      #:make-slug post-slug-v2
      #:readers (list commonmark-reader)
      #:builders (list (blog #:theme trqt-theme
                             #:prefix "/blog"
                             #:collections %blog-collection)
                       index-page
                       (atom-feed)
                       (atom-feeds-by-tag)
                       ;(static-directory "images")
                       ))


