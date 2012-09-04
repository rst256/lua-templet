#
# Templet for Lua.
# Copyright © 2012 Peter Colberg.
# For conditions of distribution and use, see copyright notice in LICENSE.
#

LUA = lua

ifdef LUA_PATH
LUA_PATH := $(CURDIR)/../?.lua;$(CURDIR)/../?/init.lua;$(LUA_PATH)
else
LUA_PATH := $(CURDIR)/../?.lua;$(CURDIR)/../?/init.lua;;
endif
export LUA_PATH

TESTS = templet

all: $(TESTS)

$(TESTS):
	$(LUA) $@.lua

.PHONY: $(TESTS)
