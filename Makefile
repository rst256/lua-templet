#
# Templet for Lua.
# Copyright © 2012 Peter Colberg.
# For conditions of distribution and use, see copyright notice in LICENSE.
#

PREFIX = /usr/local
LUADIR = $(PREFIX)/share/lua/5.1
DOCDIR = $(PREFIX)/share/doc/lua-templet

INSTALL_D = mkdir -p
INSTALL_F = install -m 644

FILES_LUA = init.lua
FILES_DOC = index.mdwn INSTALL.mdwn README.mdwn reference.mdwn CHANGES.mdwn
FILES_DOC_HTML = index.html INSTALL.html README.html reference.html CHANGES.html pandoc.css lua-templet.png

all: doc

test:
	@$(MAKE) -C test

doc:
	@$(MAKE) -C doc

install:
	$(INSTALL_D) $(DESTDIR)$(LUADIR)/templet
	cd templet && $(INSTALL_F) $(FILES_LUA) $(DESTDIR)$(LUADIR)/templet
	$(INSTALL_D) $(DESTDIR)$(DOCDIR)
	cd doc && $(INSTALL_F) $(FILES_DOC) $(FILES_DOC_HTML) $(DESTDIR)$(DOCDIR)

clean:
	@$(MAKE) -C doc clean

.PHONY: test doc install clean
