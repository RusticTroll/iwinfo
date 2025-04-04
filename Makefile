IWINFO_SOVERSION   = $(if $(SOVERSION),$(SOVERSION),0)

IWINFO_BACKENDS    = $(BACKENDS)
IWINFO_CFLAGS      = $(CFLAGS) -Wall -std=gnu99 -fstrict-aliasing -Iinclude -I/usr/include/libnl3

IWINFO_LIB_OBJ     = iwinfo_utils.o iwinfo_lib.o

IWINFO_CLI         = iwinfo
IWINFO_CLI_OBJ     = iwinfo_cli.o


ifneq ($(filter wl wext madwifi,$(IWINFO_BACKENDS)),)
	IWINFO_CFLAGS  += -DUSE_WEXT
	IWINFO_LIB_OBJ += iwinfo_wext.o iwinfo_wext_scan.o
endif

ifneq ($(filter wl,$(IWINFO_BACKENDS)),)
	IWINFO_CFLAGS  += -DUSE_WL
	IWINFO_LIB_OBJ += iwinfo_wl.o
endif

ifneq ($(filter madwifi,$(IWINFO_BACKENDS)),)
	IWINFO_CFLAGS  += -DUSE_MADWIFI
	IWINFO_LIB_OBJ += iwinfo_madwifi.o
endif

ifneq ($(filter nl80211,$(IWINFO_BACKENDS)),)
	IWINFO_CFLAGS      += -DUSE_NL80211
	IWINFO_CLI_LDFLAGS += -lnl-3 -lnl-genl-3
	IWINFO_LIB_LDFLAGS += -lnl-3 -lnl-genl-3
	IWINFO_LIB_OBJ     += iwinfo_nl80211.o
endif


compile: clean $(IWINFO_LIB) $(IWINFO_CLI)

%.o: %.c
	$(CC) $(IWINFO_CFLAGS) $(FPIC) -c -o $@ $<

$(IWINFO_CLI): $(IWINFO_CLI_OBJ) $(IWINFO_LIB_OBJ)
	$(CC) $(IWINFO_LDFLAGS) $(IWINFO_CLI_LDFLAGS) -o $(IWINFO_CLI) $(IWINFO_CLI_OBJ) $(IWINFO_LIB_OBJ)

clean:
	rm -f *.o $(IWINFO_LIB) $(IWINFO_CLI)
