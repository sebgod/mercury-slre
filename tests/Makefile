include ../Make.options

EXPS := $(wildcard manual/*.exp)
RESS := $(patsubst %.exp,%.res,$(EXPS))
TEST_MODULE := test_mercury_slre
TEST_EXE    := $(TEST_MODULE)$(EXE_EXT)
SRC_FILES   := $(wildcard ../src/*.[chm])
TEST_FILES  := $(wildcard *.m)

.PHONY: runtests
runtests: $(TEST_EXE) $(RESS)

Mercury.modules: $(TEST_FILES) $(SRC_FILES)
	@echo Call test clean to ensure testing of changed code
	$(MAKE) tests.clean
	$(MMC) -f $(filter %.m,$^)

$(TEST_EXE): Mercury.modules $(SLRE_OBJ) $(SRC_FILES)
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
	$(DEL_FILE) FAILED_TESTS ABORTED_TESTS

.PHONY: clean
clean: tests.clean
	$(MMC) $(MCFLAGS) --make $(TEST_MODULE).clean

.PHONY: realclean
realclean: tests.clean
	$(MMC) $(MCFLAGS) --make $(TEST_MODULE).realclean 
	$(DEL_DIR) Mercury
	$(DEL_FILE) Mercury.modules
	$(DEL_FILE) $(SLRE_OBJ)
	$(DEL_FILE) $(TEST_EXE)
