include ../Make.options

INPS := $(wildcard manual/*.inp)
EXPS := $(wildcard manual/*.exp)
EXPS := $(patsubst %.inp,%.exp,$(INPS))
RESS := $(patsubst %.inp,%.res,$(INPS))
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

m_c :=,\s*
m_string :=\"([^\"]+)\"$(m_c)
m_num :=([0-9]+)$(m_c)
re_assert :=^\s*ASSERT[(]slre_match[(]$(m_string)$(m_string)[0-9]+$(m_c)(NULL|caps)$(m_c)$(m_num)([A-Z_]+|[0-9]+)[)]\s*==\s*([A-Z_]+|[0-9]+)[)];
manual/assert.exp: ../src/slre/unit_test.c Makefile
	$(SED) -e "N; s/(==|,|[)])\n\s*/\1 /; P; D" <$< | $(SED) -n -e "s/$(re_assert)/ok\t\1\t\2\t\3\t\4\t\5\t\6/p" - >$@

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
