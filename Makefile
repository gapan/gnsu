PREFIX ?= /usr/local
DESTDIR ?= /

build:
	@echo "Nothing to make"

clean:
	@echo "Nothing to clean"

install:
	install -Dm 755 src/gnsu $(DESTDIR)/$(PREFIX)/bin/gnsu
	install -Dm 755 src/gnsu-helper $(DESTDIR)/usr/libexec/gnsu-helper

 .PHONY: all install
