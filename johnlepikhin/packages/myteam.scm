(define-module (johnlepikhin packages myteam)
  #:use-module (gnu packages base)
  #:use-module (gnu packages bootstrap)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages elf)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages gl)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gnupg)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages ncurses)
  #:use-module (gnu packages nss)
  #:use-module (gnu packages pulseaudio)
  #:use-module (gnu packages xorg)
  #:use-module (guix build-system copy)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix licenses)
  #:use-module (guix monads)
  #:use-module (guix packages)
  #:use-module (guix store)
  #:use-module (guix utils)
  #:use-module (ice-9 match)
  #:export (make-myteam))

;; Patched version, added support of xz
(define* (url-fetch/tarbomb url hash-algo hash
                            #:optional name
                            #:key (system (%current-system))
                            (guile (default-guile)))
  "Similar to 'url-fetch' but unpack the file from URL in a directory of its
own.  This helper makes it easier to deal with \"tar bombs\"."
  (define file-name
    (match url
      ((head k v)
       (basename head))
      (z
       (basename url))))
  (define gzip
    (module-ref (resolve-interface '(gnu packages compression)) 'gzip))
  (define tar
    (module-ref (resolve-interface '(gnu packages base)) 'tar))
  (define xz
    (module-ref (resolve-interface '(gnu packages compression)) 'xz))

  (mlet %store-monad ((drv (url-fetch url hash-algo hash
                                       (string-append "tarbomb-"
                                                      (or name file-name))
                                       #:system system
                                       #:guile guile))
                      (guile (package->derivation guile system)))
    ;; Take the tar bomb, and simply unpack it as a directory.
    ;; Use ungrafted tar/gzip so that the resulting tarball doesn't depend on
    ;; whether grafts are enabled.
    (gexp->derivation (or name file-name)
                      (with-imported-modules '((guix build utils))
                        #~(begin
                            (use-modules (guix build utils))
                            (mkdir #$output)
                            (setenv "PATH" (string-append #+gzip "/bin:" #+xz "/bin"))
                            (chdir #$output)
                            (invoke (string-append #+tar "/bin/tar")
                                    "xf" #$drv)))
                      #:system system
                      #:guile-for-build guile
                      #:graft? #f
                      #:local-build? #t)))


(define (make-myteam version checksum)
  (package
    (name "myteam")
    (version version)
    (source (origin
              (method url-fetch/tarbomb)
              ;; (uri "https://dl.internal.myteam.mail.ru/downloads/linux/x64/latest/myteam.tar.xz")
              (uri (string-append "file:///tmp/myteam-" version ".tar.xz"))
              (sha256 (base32 checksum))))
    (build-system copy-build-system)
    (arguments
     `(#:install-plan
       `(("myteam" "bin/myteam")
         ("lib" "lib")
         ("plugins" "plugins"))
       #:phases
       (modify-phases
        %standard-phases
        (add-after
         'strip 'fix-binary
         (lambda*
          (#:key outputs inputs #:allow-other-keys)
          (let* ((out (assoc-ref outputs "out"))
                 (ncurses-lib
                  (string-append (assoc-ref inputs "ncurses") "/lib"))
                 (patchelf (string-append (assoc-ref inputs "patchelf") "/bin/patchelf"))
                 (binary (string-append out "/bin/myteam"))
                 (libs (string-append out "/lib/lib*.so*"
                                      " " out "/plugins/*/lib*.so*"))
                 (dynamic-linker (string-append (assoc-ref inputs "libc") ,(glibc-dynamic-linker)))
                 (nss (string-append (assoc-ref inputs "nss") "/lib/nss")))
            (system (string-append patchelf " --set-rpath \"" out "/lib:" nss ":" out "/plugins:$LIBRARY_PATH\" --set-interpreter " dynamic-linker " " binary))
            ;; (system (string-append "rm -rf " out "/lib " out "/plugins"))
            (system (string-append patchelf " --set-rpath \"" out "/lib:" nss ":" out "/plugins:$LIBRARY_PATH\" " libs))

            (symlink
             (string-append ncurses-lib "/libncursesw.so."
                            ;; Extract "6.0" from "6.0-20170930" if a
                            ;; dash-separated version tag exists.
                            ,(let* ((v (package-version ncurses))
                                    (d (or (string-index v #\-)
                                           (string-length v))))
                               (version-major+minor (string-take v d))))
             (string-append out "/lib/libtinfo.so.5"))

            #t))))))
    (synopsis "Myteam")
    (description "Myteam")
    (home-page "https://dl.internal.myteam.mail.ru//")
    (native-inputs `(("patchelf" ,patchelf)))
    (propagated-inputs `(("libxrandr" ,libxrandr)
              ("libxcomposite" ,libxcomposite)
              ("libxcursor" ,libxcursor)
              ("libxdamage" ,libxdamage)
              ("libgpg-error" ,libgpg-error)
              ("glibc" ,glibc)
              ("libfontconfig" ,fontconfig)
              ("libxau" ,libxau)
              ("pulseaudio" ,pulseaudio)
              ("dbus" ,dbus)
              ("mesa" ,mesa)
              ("glib" ,glib)
              ("libxi" ,libxi)
              ("gcc:lib" ,(canonical-package gcc) "lib")
              ("ncurses" ,ncurses)
              ("libxtst" ,libxtst)
              ("alsa-lib" ,alsa-lib)
               ("nss" ,nss)
              ("libxinerama" ,libxinerama)))
    (license gpl3+)))

(define-public myteam-10.0.8143
  (make-myteam "10.0.8143" "0f7m08lpfwxl7kaw3fsc73d4sp9sfbl6dh4yxm8mr6px8rv3g2h9"))

(define-public myteam-10.0.8804
  (make-myteam "10.0.8804" "16igq814qw63j8p7lzsj2376xf2hz1gla9yy2c9aic6fy02wi8n3"))

(define-public myteam-10.0.9663
  (make-myteam "10.0.9663" "1kpksd3icgk9051i05baznrawy958a4qvw753fmxalsb6dxgflqv"))

(define-public myteam myteam-10.0.9663)
