(define-module (johnlepikhin packages zoom)
  #:use-module ((guix licenses) #:select (non-copyleft))
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix utils)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages base)
  #:use-module (gnu packages elf)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages bootstrap)
  #:use-module (gnu packages gl)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages xorg)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages qt)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages pulseaudio)
  #:use-module (gnu packages linux)
  #:use-module (guix store)
  #:use-module (guix gexp)
  #:use-module (guix build-system copy)
  #:export (make-zoom))

(define license:zoomus
  (non-copyleft "Proprietary Zoom.us license"
                "https://zoom.us/ru/terms.html"))

(define (make-zoom version checksum)
  (package
   (name "zoom")
   (version version)
   (source (origin
            (method url-fetch)
            (uri "https://zoom.us/client/latest/zoom_x86_64.tar.xz")
            (sha256 (base32 checksum))))
   (build-system copy-build-system)
   (arguments
    `(#:install-plan
      `(("zoom" "zoom/bin/")
        ("zopen" "zoom/bin/")
        ("ZoomLauncher" "zoom/bin/")
        ("libfdkaac2.so" "zoom/bin/")
        ("libicudata.so" "zoom/bin/")
        ("libicudata.so.56" "zoom/bin/")
        ("libicudata.so.56.1" "zoom/bin/")
        ("libicui18n.so" "zoom/bin/")
        ("libicui18n.so.56" "zoom/bin/")
        ("libicui18n.so.56.1" "zoom/bin/")
        ("libicuuc.so" "zoom/bin/")
        ("libicuuc.so.56" "zoom/bin/")
        ("libicuuc.so.56.1" "zoom/bin/")
        ("libmpg123.so" "zoom/bin/")
        ("libQt5Core.so" "zoom/bin/")
        ("libQt5Core.so.5" "zoom/bin/")
        ("libQt5Core.so.5.12" "zoom/bin/")
        ("libQt5Core.so.5.12.10" "zoom/bin/")
        ("libQt5DBus.so" "zoom/bin/")
        ("libQt5DBus.so.5" "zoom/bin/")
        ("libQt5DBus.so.5.12" "zoom/bin/")
        ("libQt5DBus.so.5.12.10" "zoom/bin/")
        ("libQt5Gui.so" "zoom/bin/")
        ("libQt5Gui.so.5" "zoom/bin/")
        ("libQt5Gui.so.5.12" "zoom/bin/")
        ("libQt5Gui.so.5.12.10" "zoom/bin/")
        ("libQt5Network.so" "zoom/bin/")
        ("libQt5Network.so.5" "zoom/bin/")
        ("libQt5Network.so.5.12" "zoom/bin/")
        ("libQt5Network.so.5.12.10" "zoom/bin/")
        ("libQt5OpenGL.so" "zoom/bin/")
        ("libQt5OpenGL.so.5" "zoom/bin/")
        ("libQt5OpenGL.so.5.12" "zoom/bin/")
        ("libQt5OpenGL.so.5.12.10" "zoom/bin/")
        ("libQt5Qml.so" "zoom/bin/")
        ("libQt5Qml.so.5" "zoom/bin/")
        ("libQt5Qml.so.5.12" "zoom/bin/")
        ("libQt5Qml.so.5.12.10" "zoom/bin/")
        ("libQt5QuickControls2.so" "zoom/bin/")
        ("libQt5QuickControls2.so.5" "zoom/bin/")
        ("libQt5QuickControls2.so.5.12" "zoom/bin/")
        ("libQt5QuickControls2.so.5.12.10" "zoom/bin/")
        ("libQt5QuickShapes.so" "zoom/bin/")
        ("libQt5QuickShapes.so.5" "zoom/bin/")
        ("libQt5QuickShapes.so.5.12" "zoom/bin/")
        ("libQt5QuickShapes.so.5.12.10" "zoom/bin/")
        ("libQt5Quick.so" "zoom/bin/")
        ("libQt5Quick.so.5" "zoom/bin/")
        ("libQt5Quick.so.5.12" "zoom/bin/")
        ("libQt5Quick.so.5.12.10" "zoom/bin/")
        ("libQt5QuickTemplates2.so" "zoom/bin/")
        ("libQt5QuickTemplates2.so.5" "zoom/bin/")
        ("libQt5QuickTemplates2.so.5.12" "zoom/bin/")
        ("libQt5QuickTemplates2.so.5.12.10" "zoom/bin/")
        ("libQt5QuickWidgets.so" "zoom/bin/")
        ("libQt5QuickWidgets.so.5" "zoom/bin/")
        ("libQt5QuickWidgets.so.5.12" "zoom/bin/")
        ("libQt5QuickWidgets.so.5.12.10" "zoom/bin/")
        ("libQt5Script.so" "zoom/bin/")
        ("libQt5Script.so.5" "zoom/bin/")
        ("libQt5Script.so.5.12" "zoom/bin/")
        ("libQt5Script.so.5.12.10" "zoom/bin/")
        ("libQt5Svg.so" "zoom/bin/")
        ("libQt5Svg.so.5" "zoom/bin/")
        ("libQt5Svg.so.5.12" "zoom/bin/")
        ("libQt5Svg.so.5.12.10" "zoom/bin/")
        ("libQt5WaylandClient.so" "zoom/bin/")
        ("libQt5WaylandClient.so.5" "zoom/bin/")
        ("libQt5WaylandClient.so.5.12" "zoom/bin/")
        ("libQt5WaylandClient.so.5.12.10" "zoom/bin/")
        ("libQt5WaylandCompositor.so" "zoom/bin/")
        ("libQt5WaylandCompositor.so.5" "zoom/bin/")
        ("libQt5WaylandCompositor.so.5.12" "zoom/bin/")
        ("libQt5WaylandCompositor.so.5.12.10" "zoom/bin/")
        ("libQt5Widgets.so" "zoom/bin/")
        ("libQt5Widgets.so.5" "zoom/bin/")
        ("libQt5Widgets.so.5.12" "zoom/bin/")
        ("libQt5Widgets.so.5.12.10" "zoom/bin/")
        ("libQt5X11Extras.so" "zoom/bin/")
        ("libQt5X11Extras.so.5" "zoom/bin/")
        ("libQt5X11Extras.so.5.12" "zoom/bin/")
        ("libQt5X11Extras.so.5.12.10" "zoom/bin/")
        ("libQt5XcbQpa.so" "zoom/bin/")
        ("libQt5XcbQpa.so.5" "zoom/bin/")
        ("libQt5XcbQpa.so.5.12" "zoom/bin/")
        ("libQt5XcbQpa.so.5.12.10" "zoom/bin/")
        ("libquazip.so" "zoom/bin/")
        ("libturbojpeg.so" "zoom/bin/")
        ("audio" "zoom/bin/")
        ("platforms" "zoom/bin/")
        ("imageformats" "zoom/bin/")
        ("iconengines" "zoom/bin/")
        ("dingdong1.pcm", "zoom/bin/")
        ("dingdong.pcm", "zoom/bin/")
        ("double_beep.pcm", "zoom/bin/")
        ("Droplet.pcm", "zoom/bin/")
        ("Embedded.properties", "zoom/bin/")
        ("leave.pcm", "zoom/bin/")
        ("meeting_chat_chime.pcm", "zoom/bin/")
        ("meeting_raisehand_chime.pcm", "zoom/bin/")
        ("record_start.pcm", "zoom/bin/")
        ("record_stop.pcm", "zoom/bin/")
        ("ring.pcm", "zoom/bin/")
        ("wr_ding.pcm", "zoom/bin/")
        ("ringtone", "zoom/bin/")
        ("qt.conf", "zoom/bin/")
        ("xcbglintegrations", "zoom/bin/")
        ("Qt" "zoom/bin/")
        ("QtGraphicalEffects" "zoom/bin/")
        ("QtQuick" "zoom/bin/")
        ("QtQuick.2" "zoom/bin/")
        ("QtQml" "zoom/bin/")
        ("json" "zoom/bin/")
        ("sip" "zoom/bin/")
        ("timezones" "zoom/bin/")
        ("translations" "zoom/bin/")
        )
      #:phases
      (modify-phases
       %standard-phases
       (add-after
        'strip 'fix-binary
        (lambda*
            (#:key outputs inputs #:allow-other-keys)
          (let* ((out (assoc-ref outputs "out"))
                 (patchelf (string-append (assoc-ref inputs "patchelf") "/bin/patchelf"))
                 (binary (string-append 
                          out "/zoom/bin/zoom"
                          " " out "/zoom/bin/zopen"
                          " " out "/zoom/bin/ZoomLauncher"))
                 (libs (string-append 
                        out "/zoom/bin/lib*.so"
                        " " out "/zoom/bin/*/lib*.so"
                        " " out "/zoom/bin/*/*/lib*.so"
                        " " out "/zoom/bin/*/*/*/lib*.so"
                        " " out "/zoom/bin/*/*/*/*/lib*.so"
                        ))
                 (dynamic-linker (string-append (assoc-ref inputs "libc") ,(glibc-dynamic-linker))))
            (system (string-append patchelf " --set-rpath \"" out "/zoom/bin:$LIBRARY_PATH\" --set-interpreter " dynamic-linker " " binary))
            (system (string-append patchelf " --set-rpath \"" out "/zoom/bin:$LIBRARY_PATH\" " libs))
            (system (string-append "rm -rf"
                                   " " out "/zoom/bin/QtQuick/Scene3D"
                                   " " out "/zoom/bin/QtQuick/Scene2D"
                                   " " out "/zoom/bin/QtQuick/Particles.2"
                                   " " out "/zoom/bin/Qt/labs/location"
                                   " " out "/zoom/bin/QtQuick/LocalStorage"
                                   " " out "/zoom/bin/QtQuick/XmlListModel"
                                   " " out "/zoom/bin/egldeviceintegrations"
                                   " " out "/zoom/bin/platforms/libqeglfs.so"))
            (mkdir-p (string-append out "/bin"))
            (system (string-append "ln -s " out "/zoom/bin/zoom " out "/bin/zoom"))
            (system (string-append "ln -s " out "/zoom/bin/ZoomLauncher " out "/bin/ZoomLauncher"))
            #t)))
       (add-after
        'install 'finalize-install
        (lambda* (#:key outputs #:allow-other-keys)
          (let ((out (assoc-ref outputs "out")))
            (let ((apps (string-append out "/share/applications")))
              (mkdir-p apps)
              (make-desktop-entry-file
               (string-append apps "/zoom.desktop")
               #:name "Zoom"
               #:exec (string-append out "/zoom/bin/ZoomLauncher %U")
               #:mime-type (list
                            "x-scheme-handler/zoommtg"
                            "x-scheme-handler/zoomus"
                            "x-scheme-handler/tel"
                            "x-scheme-handler/callto"
                            "x-scheme-handler/zoomphonecall")
               #:categories '("Network" "Application")
               #:comment
               '(("en" "Zoom Video Conference")
                 (#f "Zoom Video Conference")))
              #t)))))))
   (synopsis "Zoom")
   (description "Zoom")
   (home-page "https://zoom.us")
   (native-inputs `(("patchelf" ,patchelf)))
   (propagated-inputs
    `(("alsa-lib" ,alsa-lib)
      ("atk" ,atk)
      ("cairo" ,cairo)
      ("dbus" ,dbus)
      ("fontconfig" ,fontconfig)
      ("freetype" ,freetype)
      ("gcc:lib" ,(canonical-package gcc) "lib")
      ("gdk-pixbuf+svg" ,gdk-pixbuf+svg)
      ("glib" ,glib)
      ("gtk+" ,gtk+)
      ("libdrm" ,libdrm)
      ("libx11" ,libx11)
      ("libxcb" ,libxcb)
      ("libxcomposite" ,libxcomposite)
      ("libxext" ,libxext)
      ("libxfixes" ,libxfixes)
      ("libxkbcommon" ,libxkbcommon)
      ("libxrender" ,libxrender)
      ("libxtst" ,libxtst)
      ("mesa" ,mesa)
      ("pango" ,pango)
      ("pulseaudio" ,pulseaudio)
      ("qtmultimedia" ,qtmultimedia)
      ("wayland" ,wayland)
      ("xcb-util-image" ,xcb-util-image)
      ("xcb-util-keysyms" ,xcb-util-keysyms)
      ("zlib" ,zlib)))
   (license license:zoomus)))

(define-public zoom-5.7.6.31792.0820 (make-zoom "5.7.6.31792.0820" "0bdi3qvln9iznn2j4mh4vihplw5hygj93ssmfrmdk7sv0c3rlgrm"))

(define-public zoom zoom-5.7.6.31792.0820)
