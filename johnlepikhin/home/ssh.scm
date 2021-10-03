(define-module (johnlepikhin home bash)
  #:export (home-ssh-host-configuration
            home-ssh-configuration
            home-ssh-service-type))

(define-record-type* <home-ssh-host-configuration>
  home-ssh-host-configuration make-home-ssh-host-configuration
  home-ssh-host-configuration?
  (host-mask home-ssh-host-configuration-host-mask)
  (hostname home-ssh-host-configuration-hostname (default #f))
  (port home-ssh-host-configuration-port (default #f))
  (user home-ssh-host-configuration-user (default #f))
  (compression home-ssh-host-configuration-compression (default #f))
  (server-alive-interval home-ssh-host-configuration-server-alive-interval (default #f))
  (connect-timeout home-ssh-host-configuration-connect-timeout (default #f))
  (control-master home-ssh-host-configuration-control-master (default #f))
  (control-persist home-ssh-host-configuration-control-persist (default #f))
  (proxy-jump home-ssh-host-configuration-proxy-jump (default #f))
  (comment home-ssh-host-configuration-comment (default #f)))

(define (serialize-home-ssh-host-configuration val)
  (string-append
   (if (home-ssh-host-configuration-comment val)
       (format #f "# ~a\n" (home-ssh-host-configuration-comment val)) "")
   (format #f "Host ~a\n" (home-ssh-host-configuration-host-mask val))
   (if (home-ssh-host-configuration-hostname val)
       (format #f "  Hostname ~a\n" (home-ssh-host-configuration-hostname val)) "")
   (if (home-ssh-host-configuration-port val)
       (format #f "  Port ~d\n" (home-ssh-host-configuration-port val)) "")
   (if (home-ssh-host-configuration-user val)
       (format #f "  User ~a\n" (home-ssh-host-configuration-user val)) "")
   (if (home-ssh-host-configuration-compression val)
       (format #f "  Compression yes\n") "")
   (if (home-ssh-host-configuration-server-alive-interval val)
       (format #f "  ServerAliveInterval ~d\n" (home-ssh-host-configuration-server-alive-interval val)) "")
   (if (home-ssh-host-configuration-connect-timeout val)
       (format #f "  ConnectTimeout ~d\n" (home-ssh-host-configuration-connect-timeout val)) "")
   (if (home-ssh-host-configuration-control-master val)
       (format #f "  ControlMaster ~a\n" (home-ssh-host-configuration-control-master val)) "")
   (if (home-ssh-host-configuration-control-persist val)
       (format #f "  ControlPersist yes\n") "")
   (if (home-ssh-host-configuration-proxy-jump val)
       (format #f "  ProxyJump ~a\n" (home-ssh-host-configuration-proxy-jump val)) "")
   "\n"))

(define-record-type* <home-ssh-configuration>
  home-ssh-configuration make-home-ssh-configuration
  home-ssh-configuration?
  (connections-dir home-ssh-configuration-connections-dir
                   (default (string-append (getenv "XDG_RUNTIME_DIR") "/ssh-connections")))
  (hosts home-ssh-configuration-hosts (default '())))

(define (add-ssh-config-file config)
  `(("ssh/config"
     ,(mixed-text-file
       "ssh-config"
       #~(string-append
          #$@(append
              (list "ControlPath " (home-ssh-configuration-connections-dir config) "/%h:%p:%r\n\n")
              (map (lambda (host)
                     (serialize-home-ssh-host-configuration host))
                   (home-ssh-configuration-hosts config))))))))
  
(define (add-ssh-extensions config extensions)
  (home-ssh-configuration
   (inherit config)
   (hosts
    (append (home-ssh-configuration-hosts config)
            extensions))))

(define (home-ssh-activation config)
  (let* ((connections-dir (home-ssh-configuration-connections-dir config)))
    #~(begin
        (format #t "Creating ~a for persistent ssh connections storage\n" #$connections-dir)
        (mkdir-p #$connections-dir))))

(define home-ssh-service-type
  (service-type (name 'home-ssh)
                (extensions
                 (list
                  (service-extension home-files-service-type add-ssh-config-file)
                  (service-extension home-activation-service-type home-ssh-activation)
                  ))
                (compose concatenate)
                (extend add-ssh-extensions)
                (default-value (home-ssh-configuration))
                (description "Create @file{~/.ssh/config}")))
