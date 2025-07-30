(define-module (pages index)
  #:use-module (utils)
  #:use-module (haunt artifact)
  #:use-module (haunt builder blog)
  #:use-module (haunt html)
  #:use-module (theme) 
  #:export (index-page))

(define (static-page title file-name body)
  "Create HTML page with the given TITLE written to FILE-NAME, with contents BODY"
  (lambda (site posts)
    (serialized-artifact
     (if (string-suffix? ".html" file-name)
         file-name
         (string-append file-name "/index.html"))
     (with-layout trqt-theme site title body)
     sxml->html)))

(define index-page
  (static-page
   "Hi! I'm Guilherme Torquato"
   "index.html"
   `((div (@ (class "about-me"))
          (main (@ (class "index-text"))
                (p "I am student at "
                   ,(link "University of São Paulo" "https://usp.br")
                   ". I'm mostly interested in cybersecurity, software engineering and maths, but I could be nerd sniped.")
                (p "I am currently a player for "
                   ,(link "Ganesh" "https://ganesh.icmc.usp.br")
                   ", playing CTFs every saturday.")
                (p "I am a "
                   ,(link "GNU Emacs" "https://www.gnu.org/software/emacs/")
                   " user and I currently use "
                   ,(link "NixOS" "https://guix.gnu.org/")
                   " to manage my computing environment "
                   ,(link "mynix" "https://github.com/trqt/mynix") ". "))))))
