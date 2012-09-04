#
# Templet for Lua.
# Copyright © 2012 Peter Colberg.
# For conditions of distribution and use, see copyright notice in LICENSE.
#

PREFIX = /usr/local

INSTALL_LMOD = $(PREFIX)/share/lua/5.1/templet
INSTALL_DIR = mkdir -p
INSTALL_DATA = install -m 644

FILES_LMOD = init.lua

test:
	@$(MAKE) -C test

install:
	$(INSTALL_DIR) $(DESTDIR)$(INSTALL_LMOD)
	cd templet && $(INSTALL_DATA) $(FILES_LMOD) $(DESTDIR)$(INSTALL_LMOD)

clean:
	@$(MAKE) -C doc clean

.PHONY: test install clean
