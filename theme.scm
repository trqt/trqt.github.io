(define-module (theme)
  #:use-module (ice-9 match)
  #:use-module (srfi srfi-19)           ; dates
  #:use-module (rnrs bytevectors)
  #:use-module (haunt site)
  #:use-module (haunt post)
  #:use-module (haunt utils)
  #:use-module (haunt builder blog)
  #:use-module (utils) 
  #:export (trqt-theme))

(define %copyright #vu8(194 169))

(define %right-arrow #vu8(226 134 146))
;; 0xe2 0x84 0xa2

(define %cc-by-sa-button
  '(a (@ (class "cc-button")
         (href "https://creativecommons.org/licenses/by-sa/4.0/"))
      (img (@ (src "https://licensebuttons.net/l/by-sa/4.0/80x15.png")))))


(define (stylesheet name)
  "Link a stylesheet by stylesheet NAME to its corresponding file in /css/ directory"
  `(link (@ (rel "stylesheet")
            (href ,(string-append "/css/" name ".css")))))

(define (javascript name)
  "Link a Javascript file by NAME to its file in the built /js/ directory."
  `(script (@ (src ,(string-append "/js/" name)))))

(define trqt-theme
  (theme #:name "trqt-theme"
         #:layout
         (lambda (site title body)
           `((doctype "html")
             (html (@ (lang "en"))
                   (head
                    (meta (@ (charset "utf-8")))
                    (meta (@ (name "description")
                             (content "Guilherme Torquato's web portal")))
                    (link (@ (rel "icon")
                             (type "image/x-icon")
                             (href "/assets/favicon/favicon.ico")))
                    (link (@ (rel "alternate")
                             (type "application/atom+xml")
                             (title "trqt Atom Feed")
                             (href "/feed.xml")))
                    (meta (@ (name "viewport")
                             (content "width=device-width, initial-scale=1.0")))
                    (meta (@ (name "color-scheme")
                             (content ,(string-join
                                        ;; Page supports dark & light, and author
                                        ;; prefers dark.
                                        (list "dark" "light")))))
                    (meta (@ (property "og:title")
                             (content ,title)))
                    (meta (@ (name "og:author")
                             (content ,(assoc-ref (site-default-metadata site) 'author))))
                    (title ,title)
                    ;; ,(stylesheet "core")
                    ;; Main body of the particular page we are on
                    (body
                     ;; Setup navigation (shared between all pages)
                     (div (@ (class "container"))
                          (nav (@ (class "site-navigation")
                                  (id "site-navigation")
                                  (aria-labelledby "site-navigation"))
                               (menu (@ (class "nav-brand"))
                                     (li ,(link "trqt" "/"))
                                     )
                               (menu (@ (class "nav-headers"))
                                     (li ,(link "Blog" "/blog"))
                                     ;; (li ,(link "CV" "/resume"))
                                     ;; (li ,(link "CTFs" "/ctf"))
                                     (li ,(link "GitHub" "https://github.com/trqt"))))
                          ;; The body of the page tree is rendered and remains unchanged
                          (header (@ (class "page-title"))
                                  (h1 ,title))
                          ,body
                          ;; The footer of the page
                          (footer (@ (style "text-align: center;"))
                                  (hr)
                                  (p "Built using " ,(link "Guile" "https://www.gnu.org/software/guile/")
                                     ", " ,(link "Emacs" "https://www.gnu.org/software/emacs/")
                                     ", and " ,(link "Haunt" "https://dthompson.us/projects/haunt.html"))
                                  (a (@ (rel "license")
                                        (href "http://creativecommons.org/licenses/by-sa/4.0/"))
                                     ,%cc-by-sa-button
                                     " by "
                                     (a (@ (xmlns:cc "http://creativecommons.org/ns#")
                                           (property "cc:attributionName")
                                           (rel "cc:attributionURL")
                                           (href "http://trqt.github.io"))
                                        "Guilherme Torquato"))
                                  )))))))
         ;; How to layout an individual post from my blog
         #:post-template
         (lambda (post)
           `((hgroup
              ,(post-html-datetime post)
              ,(post-tags-sxml post))
             (article
              ,(post-sxml post))))
         ;; How to layout the collection page for my blog
         #:collection-template
         (lambda (site title posts prefix)
           `(,(map (lambda (post)
                     (let ((uri (string-append "/blog/" ;; TODO: better way to get prefix
                                               (site-post-slug site post)
                                               ".html")))
                       `(article
                         (h2 (a (@ (href ,uri))
                                ,(post-ref post 'title)))
                         ,(post-html-datetime post)
                         (div (@ (class "post"))
                              ,(post-ref post 'summary))
                         (a (@ (href ,uri)) "read more "
                            ,(utf8->string %right-arrow)))))
                   posts)))))
