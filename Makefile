include Make.options

.PHONY: default
default:
	cd src && $(MAKE) default

.PHONY: clean
clean:
	cd src && $(MAKE) clean
	cd tests && $(MAKE) clean

.PHONY: realclean
realclean:
	cd src && $(MAKE) realclean
	cd tests && $(MAKE) realclean

.PHONY: tests
tests:
	cd tests && $(MAKE) runtests

.PHONY: all
all: default tests
