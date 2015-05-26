# vim: ft=make tw=78 ts=4 sw=4 noet
include ../Make.options
include Mercury.options

.PHONY: default
default: $(SLRE_OBJ)
	$(MMC) $(MCFLAGS) --link-object $^ -m

$(SLRE_OBJ): slre.c slre.h
	$(CC) -c $(SLRE_CFLAGS) $<

slre.%: slre/slre.%
	$(HARDLINK) $^ $@

.PHONY: clean
clean:
	$(MMC) $(MCFLAGS) -m $(MAIN_TARGET).clean

.PHONY: realclean
realclean:
	$(MMC) $(MCFLAGS) -m $(MAIN_TARGET).realclean
	$(DEL_DIR) Mercury
	$(foreach EXT,gch err mh so a lib dylib init,$(DEL_FILE) *.$(EXT);)
	$(DEL_FILE) slre.[och] slre.obj
