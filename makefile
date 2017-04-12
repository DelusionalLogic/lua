# makefile for building Lua
# see INSTALL for installation instructions
# see ../Makefile and luaconf.h for further customization

# == CHANGE THE SETTINGS BELOW TO SUIT YOUR ENVIRONMENT =======================

# Warnings valid for both C and C++
CWARNSCPP= \
	-pedantic \
	-Wextra \
	-Wshadow \
	-Wsign-compare \
	-Wundef \
	-Wwrite-strings \
	-Wredundant-decls \
	-Wdisabled-optimization \
	-Waggregate-return \
	-Wdouble-promotion \
	#-Wno-aggressive-loop-optimizations   # not accepted by clang \
	#-Wlogical-op   # not accepted by clang \
	# the next warnings generate too much noise, so they are disabled
	# -Wconversion  -Wno-sign-conversion \
	# -Wsign-conversion \
	# -Wconversion \
	# -Wstrict-overflow=2 \
	# -Wformat=2 \
	# -Wcast-qual \

# The next warnings are neither valid nor needed for C++
CWARNSC= -Wdeclaration-after-statement \
	-Wmissing-prototypes \
	-Wnested-externs \
	-Wstrict-prototypes \
	-Wc++-compat \
	-Wold-style-definition \


CWARNS= $(CWARNSCPP)  $(CWARNSC)


# -DEXTERNMEMCHECK -DHARDSTACKTESTS -DHARDMEMTESTS -DTRACEMEM='"tempmem"'
# -g -DLUA_USER_H='"ltests.h"'
# -pg -malign-double
# -DLUA_USE_CTYPE -DLUA_USE_APICHECK
# (in clang, '-ftrapv' for runtime checks of integer overflows)
# -fsanitize=undefined -ftrapv
TESTS= -DLUA_USER_H='"ltests.h"'

# -mtune=native -fomit-frame-pointer
# -fno-stack-protector
LOCAL = $(TESTS) $(CWARNS) -g



# enable Linux goodies
MYCFLAGS= $(LOCAL) -std=c99 -DLUA_USE_LINUX -DLUA_COMPAT_5_2
MYLDFLAGS= $(LOCAL) -Wl,-E
MYLIBS= -ldl -lreadline


CC= clang
CFLAGS= -Wall -g -O0 $(MYCFLAGS)
AR= ar rcu
RANLIB= ranlib
RM= rm -f



# == END OF USER SETTINGS. NO NEED TO CHANGE ANYTHING BELOW THIS LINE =========


LIBS = -lm

CORE_T=	liblua.a
CORE_O=	lapi.o lcode.o lctype.o ldebug.o ldo.o ldump.o lfunc.o lgc.o llex.o \
	lmem.o lobject.o lopcodes.o lparser.o lstate.o lstring.o ltable.o \
	ltm.o lundump.o lvm.o lzio.o ltests.o
AUX_O=	lauxlib.o
LIB_O=	lbaselib.o ldblib.o liolib.o lmathlib.o loslib.o ltablib.o lstrlib.o \
	lutf8lib.o lbitlib.o loadlib.o lcorolib.o linit.o
DEC_O=	dec64_extra.o dec64_math.o dec64_string.o dec64.o

LUA_T=	lua
LUA_O=	lua.o

# LUAC_T=	luac
# LUAC_O=	luac.o print.o

ALL_T= $(CORE_T) $(LUA_T) $(LUAC_T)
ALL_O= $(CORE_O) $(LUA_O) $(LUAC_O) $(AUX_O) $(LIB_O) $(DEC_O)
ALL_A= $(CORE_T)

all:	$(ALL_T)

o:	$(ALL_O)

a:	$(ALL_A)

$(CORE_T): $(CORE_O) $(AUX_O) $(LIB_O) $(DEC_O)
	$(AR) $@ $?
	$(RANLIB) $@

$(LUA_T): $(LUA_O) $(CORE_T)
	$(CC) -o $@ $(MYLDFLAGS) $(LUA_O) $(CORE_T) $(LIBS) $(MYLIBS) $(DL)

$(LUAC_T): $(LUAC_O) $(CORE_T)
	$(CC) -o $@ $(MYLDFLAGS) $(LUAC_O) $(CORE_T) $(LIBS) $(MYLIBS)

clean:
	rcsclean -u
	$(RM) $(ALL_T) $(ALL_O)

depend:
	@$(CC) $(CFLAGS) -MM *.c DEC64/dec64_math.c DEC64/dec64_string.c

echo:
	@echo "CC = $(CC)"
	@echo "CFLAGS = $(CFLAGS)"
	@echo "AR = $(AR)"
	@echo "RANLIB = $(RANLIB)"
	@echo "RM = $(RM)"
	@echo "MYCFLAGS = $(MYCFLAGS)"
	@echo "MYLDFLAGS = $(MYLDFLAGS)"
	@echo "MYLIBS = $(MYLIBS)"
	@echo "DL = $(DL)"

$(ALL_O): makefile

# DO NOT EDIT
# automatically made with 'gcc -MM l*.c'

dec64_extra.o: dec64_extra.c DEC64/dec64.h DEC64/dec64_math.h
dec64.o: DEC64/dec64.asm DEC64/dec64.h
	jwasm -elf64 DEC64/dec64.asm
lapi.o: lapi.c lprefix.h lua.h luaconf.h DEC64/dec64.h DEC64/dec64_math.h \
  dec64_extra.h ltests.h lapi.h llimits.h lstate.h lobject.h ltm.h \
  lzio.h lmem.h ldebug.h ldo.h lfunc.h lgc.h lstring.h ltable.h \
  lundump.h lvm.h
lauxlib.o: lauxlib.c lprefix.h lua.h luaconf.h DEC64/dec64.h \
  DEC64/dec64_math.h dec64_extra.h ltests.h lauxlib.h
lbaselib.o: lbaselib.c lprefix.h lua.h luaconf.h DEC64/dec64.h \
  DEC64/dec64_math.h dec64_extra.h ltests.h lauxlib.h lualib.h
lbitlib.o: lbitlib.c lprefix.h lua.h luaconf.h DEC64/dec64.h \
  DEC64/dec64_math.h dec64_extra.h ltests.h lauxlib.h lualib.h
lcode.o: lcode.c lprefix.h lua.h luaconf.h DEC64/dec64.h \
  DEC64/dec64_math.h dec64_extra.h ltests.h lcode.h llex.h lobject.h \
  llimits.h lzio.h lmem.h lopcodes.h lparser.h ldebug.h lstate.h ltm.h \
  ldo.h lgc.h lstring.h ltable.h lvm.h
lcorolib.o: lcorolib.c lprefix.h lua.h luaconf.h DEC64/dec64.h \
  DEC64/dec64_math.h dec64_extra.h ltests.h lauxlib.h lualib.h
lctype.o: lctype.c lprefix.h lctype.h lua.h luaconf.h DEC64/dec64.h \
  DEC64/dec64_math.h dec64_extra.h ltests.h llimits.h
ldblib.o: ldblib.c lprefix.h lua.h luaconf.h DEC64/dec64.h \
  DEC64/dec64_math.h dec64_extra.h ltests.h lauxlib.h lualib.h
ldebug.o: ldebug.c lprefix.h lua.h luaconf.h DEC64/dec64.h \
  DEC64/dec64_math.h dec64_extra.h ltests.h lapi.h llimits.h lstate.h \
  lobject.h ltm.h lzio.h lmem.h lcode.h llex.h lopcodes.h lparser.h \
  ldebug.h ldo.h lfunc.h lstring.h lgc.h ltable.h lvm.h
ldo.o: ldo.c lprefix.h lua.h luaconf.h DEC64/dec64.h DEC64/dec64_math.h \
  dec64_extra.h ltests.h lapi.h llimits.h lstate.h lobject.h ltm.h \
  lzio.h lmem.h ldebug.h ldo.h lfunc.h lgc.h lopcodes.h lparser.h \
  lstring.h ltable.h lundump.h lvm.h
ldump.o: ldump.c lprefix.h lua.h luaconf.h DEC64/dec64.h \
  DEC64/dec64_math.h dec64_extra.h ltests.h lobject.h llimits.h lstate.h \
  ltm.h lzio.h lmem.h lundump.h
lfunc.o: lfunc.c lprefix.h lua.h luaconf.h DEC64/dec64.h \
  DEC64/dec64_math.h dec64_extra.h ltests.h lfunc.h lobject.h llimits.h \
  lgc.h lstate.h ltm.h lzio.h lmem.h
lgc.o: lgc.c lprefix.h lua.h luaconf.h DEC64/dec64.h DEC64/dec64_math.h \
  dec64_extra.h ltests.h ldebug.h lstate.h lobject.h llimits.h ltm.h \
  lzio.h lmem.h ldo.h lfunc.h lgc.h lstring.h ltable.h
linit.o: linit.c lprefix.h lua.h luaconf.h DEC64/dec64.h \
  DEC64/dec64_math.h dec64_extra.h ltests.h lualib.h lauxlib.h
liolib.o: liolib.c lprefix.h lua.h luaconf.h DEC64/dec64.h \
  DEC64/dec64_math.h dec64_extra.h ltests.h lauxlib.h lualib.h
llex.o: llex.c lprefix.h lua.h luaconf.h DEC64/dec64.h DEC64/dec64_math.h \
  dec64_extra.h ltests.h lctype.h llimits.h ldebug.h lstate.h lobject.h \
  ltm.h lzio.h lmem.h ldo.h lgc.h llex.h lparser.h lstring.h ltable.h
lmathlib.o: lmathlib.c lprefix.h lua.h luaconf.h DEC64/dec64.h \
  DEC64/dec64_math.h dec64_extra.h ltests.h lauxlib.h lualib.h
lmem.o: lmem.c lprefix.h lua.h luaconf.h DEC64/dec64.h DEC64/dec64_math.h \
  dec64_extra.h ltests.h ldebug.h lstate.h lobject.h llimits.h ltm.h \
  lzio.h lmem.h ldo.h lgc.h
loadlib.o: loadlib.c lprefix.h lua.h luaconf.h DEC64/dec64.h \
  DEC64/dec64_math.h dec64_extra.h ltests.h lauxlib.h lualib.h
lobject.o: lobject.c lprefix.h lua.h luaconf.h DEC64/dec64.h \
  DEC64/dec64_math.h dec64_extra.h ltests.h lctype.h llimits.h ldebug.h \
  lstate.h lobject.h ltm.h lzio.h lmem.h ldo.h lstring.h lgc.h lvm.h
lopcodes.o: lopcodes.c lprefix.h lopcodes.h llimits.h lua.h luaconf.h \
  DEC64/dec64.h DEC64/dec64_math.h dec64_extra.h ltests.h
loslib.o: loslib.c lprefix.h lua.h luaconf.h DEC64/dec64.h \
  DEC64/dec64_math.h dec64_extra.h ltests.h lauxlib.h lualib.h
lparser.o: lparser.c lprefix.h lua.h luaconf.h DEC64/dec64.h \
  DEC64/dec64_math.h dec64_extra.h ltests.h lcode.h llex.h lobject.h \
  llimits.h lzio.h lmem.h lopcodes.h lparser.h ldebug.h lstate.h ltm.h \
  ldo.h lfunc.h lstring.h lgc.h ltable.h
lstate.o: lstate.c lprefix.h lua.h luaconf.h DEC64/dec64.h \
  DEC64/dec64_math.h dec64_extra.h ltests.h lapi.h llimits.h lstate.h \
  lobject.h ltm.h lzio.h lmem.h ldebug.h ldo.h lfunc.h lgc.h llex.h \
  lstring.h ltable.h
lstring.o: lstring.c lprefix.h lua.h luaconf.h DEC64/dec64.h \
  DEC64/dec64_math.h dec64_extra.h ltests.h ldebug.h lstate.h lobject.h \
  llimits.h ltm.h lzio.h lmem.h ldo.h lstring.h lgc.h
lstrlib.o: lstrlib.c lprefix.h lua.h luaconf.h DEC64/dec64.h \
  DEC64/dec64_math.h dec64_extra.h ltests.h lauxlib.h lualib.h
ltable.o: ltable.c lprefix.h lua.h luaconf.h DEC64/dec64.h \
  DEC64/dec64_math.h dec64_extra.h ltests.h ldebug.h lstate.h lobject.h \
  llimits.h ltm.h lzio.h lmem.h ldo.h lgc.h lstring.h ltable.h lvm.h
ltablib.o: ltablib.c lprefix.h lua.h luaconf.h DEC64/dec64.h \
  DEC64/dec64_math.h dec64_extra.h ltests.h lauxlib.h lualib.h
ltests.o: ltests.c lprefix.h lua.h luaconf.h DEC64/dec64.h \
  DEC64/dec64_math.h dec64_extra.h ltests.h lapi.h llimits.h lstate.h \
  lobject.h ltm.h lzio.h lmem.h lauxlib.h lcode.h llex.h lopcodes.h \
  lparser.h lctype.h ldebug.h ldo.h lfunc.h lstring.h lgc.h ltable.h \
  lualib.h
ltm.o: ltm.c lprefix.h lua.h luaconf.h DEC64/dec64.h DEC64/dec64_math.h \
  dec64_extra.h ltests.h ldebug.h lstate.h lobject.h llimits.h ltm.h \
  lzio.h lmem.h ldo.h lstring.h lgc.h ltable.h lvm.h
lua.o: lua.c lprefix.h lua.h luaconf.h DEC64/dec64.h DEC64/dec64_math.h \
  dec64_extra.h ltests.h lauxlib.h lualib.h
lundump.o: lundump.c lprefix.h lua.h luaconf.h DEC64/dec64.h \
  DEC64/dec64_math.h dec64_extra.h ltests.h ldebug.h lstate.h lobject.h \
  llimits.h ltm.h lzio.h lmem.h ldo.h lfunc.h lstring.h lgc.h lundump.h
lutf8lib.o: lutf8lib.c lprefix.h lua.h luaconf.h DEC64/dec64.h \
  DEC64/dec64_math.h dec64_extra.h ltests.h lauxlib.h lualib.h
lvm.o: lvm.c lprefix.h lua.h luaconf.h DEC64/dec64.h DEC64/dec64_math.h \
  dec64_extra.h ltests.h ldebug.h lstate.h lobject.h llimits.h ltm.h \
  lzio.h lmem.h ldo.h lfunc.h lgc.h lopcodes.h lstring.h ltable.h lvm.h
lzio.o: lzio.c lprefix.h lua.h luaconf.h DEC64/dec64.h DEC64/dec64_math.h \
  dec64_extra.h ltests.h llimits.h lmem.h lstate.h lobject.h ltm.h \
  lzio.h
dec64_math.o: dec64_extra.c dec64_extra.h
	$(CC) -c $(CPPFLAGS) $(CFLAGS) DEC64/dec64_math.c
dec64_string.o: DEC64/dec64_string.c DEC64/dec64.h DEC64/dec64_string.h
	$(CC) -c $(CPPFLAGS) $(CFLAGS) DEC64/dec64_string.c

# (end of Makefile)
