#
# Templet for Lua.
# Copyright © 2012–2015 Peter Colberg.
# Distributed under the MIT license. (See accompanying file LICENSE.)
#

PREFIX = /usr/local
LUADIR = $(PREFIX)/share/lua/5.1
DOCDIR = $(PREFIX)/share/doc/lua-templet

INSTALL_D = mkdir -p
INSTALL_F = install -m 644

FILES_LUA = init.lua
FILES_DOC = index.mdwn INSTALL.mdwn README.mdwn examples.mdwn reference.mdwn CHANGES.mdwn
FILES_DOC_HTML = index.html INSTALL.html README.html examples.html reference.html CHANGES.html pandoc.css lua-templet.png
FILES_EXAMPLES_INCLUDE = include.lua
FILES_EXAMPLES_INCLUDE_TEST = included.lua main.lua

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
	$(INSTALL_D) $(DESTDIR)$(DOCDIR)/examples/include
	cd examples/include && $(INSTALL_F) $(FILES_EXAMPLES_INCLUDE) $(DESTDIR)$(DOCDIR)/examples/include
	$(INSTALL_D) $(DESTDIR)$(DOCDIR)/examples/include/test
	cd examples/include/test && $(INSTALL_F) $(FILES_EXAMPLES_INCLUDE_TEST) $(DESTDIR)$(DOCDIR)/examples/include/test

clean:
	@$(MAKE) -C doc clean

.PHONY: test doc install clean
