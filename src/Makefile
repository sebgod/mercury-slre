include ../Make.options

.PHONY: default
default: $(SLRE_OBJ)
	$(MMC) $(MCFLAGS) --link-object $^ -m

$(SLRE_OBJ): slre.c slre.h
	$(CC) -c $(SLRE_CFLAGS) $^

slre.%: slre/slre.%
	$(HARDLINK) $^ $@

.PHONY: clean
clean:
	$(DEL_DIR) Mercury
	$(DEL_FILE) slre.[och]
	$(DEL_FILE) *.gch
	$(DEL_FILE) *.err
	$(DEL_FILE) *.mh
	$(DEL_FILE) *.so
	$(DEL_FILE) *.a
	$(DEL_FILE) *.init
