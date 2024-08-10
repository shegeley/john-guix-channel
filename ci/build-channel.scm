(use-modules
 (guix monads)
 (guix store)
 (guix channels))

(define current-channel
 (channel
  (inherit (repository->guix-channel
            (dirname (string-append (current-filename) "/.."))))
  (name 'john)
  (introduction #f)))

(define (build-channel!)
 (with-store store
  (latest-channel-instances store (list current-channel))))

(build-channel!)
