(define-module (utils)
  #:use-module (ice-9 rdelim)
  #:use-module (srfi srfi-19)
  #:use-module (srfi srfi-1)
  #:use-module (haunt post)
  #:export (date
            stylesheet
            anchor
            link
            centered-image
            raw-snippet
            post-date-time
            post-tags-sxml
            post-html-datetime)
  #:replace (link))

(define (date year month day)
  "Create a SRFI-19 date for the given YEAR, MONTH, DAY"
  (let ((tzoffset (tm:gmtoff (localtime (time-second (current-time))))))
    (make-date 0 0 0 0 day month year tzoffset)))

(define (stylesheet name)
  `(link (@ (rel "stylesheet")
            (href ,(string-append "/css/" name ".css")))))

(define* (anchor content #:optional (uri content))
  `(a (@ (href ,uri)) ,content))

(define (link name uri)
  `(a (@ (href ,uri)) ,name))

(define* (centered-image url #:optional alt)
  `(img (@ (class "centered-image")
           (src ,url)
           ,@(if alt
                 `((alt ,alt))
                 '()))))

(define (raw-snippet code)
  `(pre (code ,(if (string? code) code (read-string code)))))

(define (post-tags-sxml post)
  "Add an HTML div element that lists all tags used in POST's metadata."
  (define (remove-last-elem l)
    "Remove the last element of L."
    (drop-right l 1))

  (let* ((tags-li (map
                   (lambda (tag)
                     `((li (@ (class "tag")) ,tag)))
                   (post-tags post)))
         ;; We use a hard-coded comma and space in the string because the
         ;; alternative is to use CSS. Using CSS would be fine, but some web
         ;; browsers (like eww) do not support CSS whatsoever. So the tags would
         ;; be just one big mashing of all letters. This lets us force readability
         ;; in non-CSS browsers. The CSS option is commented out in the main CSS
         ;; file.
         (commas (make-list (length tags-li) ", ")))
    `(ul (@ (class "tags"))
         ;; FIXME With this method, we need to drop the last comma in the map's
         ;; output list!
         ,@(remove-last-elem (append-map list tags-li commas)))))

(define (post-html-datetime post)
  "Return a properly formatted HTML <time> element for POST's datetime that
has the full datetime in the element's tag and a human-readable date in the
element's body."
  `(time (@ (datetime ,(date->string (post-date post) "~4")))
         ,(date->string (post-date post)
                                "~B ~d, ~Y")))
