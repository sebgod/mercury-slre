include ../Make.options

EXPS := $(wildcard manual/*.exp)
RESS := $(patsubst %.exp,%.res,$(EXPS))
TEST_MODULE := test_mercury_slre
TEST_EXE    := $(TEST_MODULE)$(EXE_EXT)

.PHONY: runtests
runtests: $(TEST_EXE) $(RESS)

Mercury.modules: $(wildcard *.m) $(wildcard ../src/*.m)
	@echo Call test clean to ensure testing of changed code
	$(MAKE) tests.clean
	$(MMC) -f $^

$(TEST_EXE): Mercury.modules $(SLRE_OBJ) $(wildcard ../src/*.[chm])
	$(MMC) $(MCFLAGS) --make $@ --link-object $(SLRE_OBJ) $(MLLIBS)

$(SLRE_OBJ):
	cd ../src && $(MAKE) $@
	$(HARDLINK) ../src/$@ $@

%.res: %.exp %.inp
	@echo testing $*.inp
	@./$(TEST_MODULE) < $*.inp | $(DIFF) $(DIFF_FLAGS) $< - >$*.res

.PHONY: tests.clean
tests.clean:
	$(DEL_FILE) $(RESS)

.PHONY: clean
clean: tests.clean
	$(MMC) --make $(TEST_MODULE).clean
	$(DEL_DIR) Mercury
	$(DEL_FILE) Mercury.modules
	$(DEL_FILE) FAILED_TESTS ABORTED_TESTS
	$(DEL_FILE) $(SLRE_OBJ)
	$(DEL_FILE) $(TEST_EXE)
