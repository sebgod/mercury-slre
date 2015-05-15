# vim: ft=make tw=78 ts=4 sw=4 noet
include ../Make.options

.PHONY: default
default: $(SLRE_OBJ)
	$(MMC) $(MCFLAGS) --link-object $^ -m

$(SLRE_OBJ): slre.c slre.h
	$(CC) -c $(SLRE_CFLAGS) $<

slre.%: slre/slre.%
	$(HARDLINK) $^ $@

.PHONY: clean
clean:
	$(DEL_DIR) Mercury
	$(foreach EXT,gch err mh so a lib dylib init,$(DEL_FILE) *.$(EXT);)
	$(DEL_FILE) slre.[och] slre.obj
