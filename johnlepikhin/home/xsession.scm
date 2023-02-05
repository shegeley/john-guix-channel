;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2023 Evgenii Lepikhin <johnlepikhin@gmail.com>
;;;
;;; This file is not part of GNU Guix.
;;;
;;; GNU Guix is free software; you can redistribute it and/or modify it
;;; under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 3 of the License, or (at
;;; your option) any later version.
;;;
;;; GNU Guix is distributed in the hope that it will be useful, but
;;; WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with GNU Guix.  If not, see <http://www.gnu.org/licenses/>.

(define-module (johnlepikhin home xsession)
  #:use-module (gnu services)
  #:use-module (gnu services configuration)
  #:use-module (gnu home services)
  #:use-module (srfi srfi-1)
  #:use-module (guix records)
  #:use-module (guix gexp)
  #:export (home-xsession-configuration
            home-xsession-service-type))

(define-record-type* <home-xsession-configuration>
  home-xsession-configuration make-xsession-configuration
  home-xsession-configuration?
  (root-process home-xsession-root-process (default "xmonad"))
  (components home-xsession-components (default '())))

(define (add-xsession-file config)
  `((".xsession"
     ,(computed-file
       "xsession"
       (gexp
        (begin
          (with-output-to-file
              #$output
            (lambda _ (display
                       (string-append
                        "#! /bin/sh\n\n"
                        ". ~/.profile"
                        #$@(map (lambda (component) (string-append component "\n"))
                                (home-xsession-components config))
                        "\n"
                        (ungexp (home-xsession-root-process config))
                        "\n"))))
          (chmod #$output #o755)))))))

(define (add-xsession-extensions config extensions)
  (home-xsession-configuration
   (inherit config)
   (components (append (home-xsession-components config) extensions))))

(define home-xsession-service-type
  (service-type
   (name 'home-xsession)
   (extensions
    (list
     (service-extension
      home-files-service-type add-xsession-file)))
   (compose identity)
   (extend add-xsession-extensions)
   (default-value (home-xsession-configuration))
   (description "Create @file{~/.xsession}")))
