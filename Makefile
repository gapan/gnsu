PREFIX ?= /usr/local
DESTDIR ?= /
LIBEXEC_DIR ?= /usr/libexec
PACKAGE_LOCALE_DIR ?= /usr/share/locale

all: mo man

mo:
	for i in `ls po/*.po`; do \
		msgfmt $$i -o `echo $$i | sed "s/\.po//"`.mo; \
	done

updatepo:
	for i in `ls po/*.po`; do \
		msgmerge -UNs $$i po/gnsu.pot; \
	done

pot:
	xgettext -L python -o po/gnsu.pot src/gnsu-askpass

man:
	txt2tags -o man/gnsu.man man/gnsu.t2t

clean:
	rm -f po/*.mo
	rm -f po/*.po~
	rm -f man/gnsu.man

install: install-gnsu install-mo install-man

install-gnsu:
	install -Dm 755 src/gnsu $(DESTDIR)/$(PREFIX)/bin/gnsu
	install -Dm 755 src/gnsu-helper $(DESTDIR)/$(LIBEXEC_DIR)/gnsu-helper
	install -Dm 755 src/gnsu-askpass $(DESTDIR)/$(LIBEXEC_DIR)/gnsu-askpass
	install -Dm 644 src/gnsu-askpass.glade $(DESTDIR)/$(PREFIX)/share/gnsu/gnsu-askpass.glade

install-mo:
	for i in `ls po/*.po | sed 's/.po//' | xargs -n1 basename` ;do \
		if [ ! -d $(DESTDIR)$(PACKAGE_LOCALE_DIR)/$$i/LC_MESSAGES ]; then \
			mkdir -p $(DESTDIR)$(PACKAGE_LOCALE_DIR)/$$i/LC_MESSAGES; \
		fi;\
	   	msgfmt -o $(DESTDIR)$(PACKAGE_LOCALE_DIR)/$$i/LC_MESSAGES/gnsu.mo po/$$i.po; \
	done

install-man:
	install -Dm 644 man/gnsu.man $(DESTDIR)/$(PREFIX)/man/man8/gnsu.8

.PHONY: mo updatepo pot man clean install install-gnsu install-mo install-man
