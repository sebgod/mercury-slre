include ../Make.options

EXPS := $(wildcard internal/*.exp)
RESS := $(patsubst %.exp,%.res,$(EXPS))

.PHONY: runtests
runtests: $(RESS)

Mercury.modules: $(wildcard *.m) $(wildcard ../src/*.m)
	@echo Call test clean to ensure testing of changed code
	$(MAKE) tests.clean
	$(MMC) -f $^

test_mercury_slre: Mercury.modules $(SLRE_OBJ)
	$(MMC) $(MCFLAGS) --make $@ --link-object $(SLRE_OBJ) $(MLLIBS)

$(SLRE_OBJ):
	cd ../src && $(MAKE) $@
	$(HARDLINK) ../src/$@ $@

%.res: %.exp
	@echo testing $*
	$(CURL) $(CURL_FLAGS) http://127.0.0.1:$(SLRE_TEST_PORT)/$* | \
		$(DIFF) $(DIFF_FLAGS) $< - >$*.res

.PHONY: tests.clean
tests.clean:
	$(DEL_FILE) $(RESS)

.PHONY: clean
clean: tests.clean
	$(MMC) --make test_mercury_slre.clean
	$(DEL_DIR) Mercury
	$(DEL_FILE) Mercury.modules
	$(DEL_FILE) FAILED_TESTS ABORTED_TESTS
	$(DEL_FILE) $(SLRE_OBJ)
	$(DEL_FILE) test_mercury_slre$(EXE_EXT)
