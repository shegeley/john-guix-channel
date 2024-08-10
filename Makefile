repl-exp := '((@ (nrepl server) run-nrepl-server) \#:port 7888)'

nrepl:
	guix shell \
	guile-next \
	guile-ares-rs \
	-- guile \
	-e $(repl-exp)

build-channel:
	guix shell guile-next -- guile -s ci/build-channel.scm
