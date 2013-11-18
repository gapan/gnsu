PREFIX ?= /usr/local
DESTDIR ?= /
LIBEXEC_DIR ?= /usr/libexec
PACKAGE_LOCALE_DIR ?= /usr/share/locale

mo:
	for i in `ls po/*.po`; do \
		msgfmt $$i -o `echo $$i | sed "s/\.po//"`.mo; \
	done

updatepo:
	for i in `ls po/*.po`; do \
		msgmerge -UNs $$i po/gnsu.pot; \
	done

pot:
	xgettext -L shell -o po/gnsu.pot src/gnsu

clean:
	rm -f po/*.mo
	rm -f po/*.po~

install:
	install -Dm 755 src/gnsu $(DESTDIR)/$(PREFIX)/bin/gnsu
	install -Dm 755 src/gnsu-helper $(DESTDIR)/$(LIBEXEC_DIR)/gnsu-helper
	for i in `ls po/*.po | sed 's/.po//' | xargs -n1 basename` ;do \
		if [ ! -d $(DESTDIR)$(PACKAGE_LOCALE_DIR)/$$i/LC_MESSAGES ]; then \
			mkdir -p $(DESTDIR)$(PACKAGE_LOCALE_DIR)/$$i/LC_MESSAGES; \
		fi;\
	   	msgfmt -o $(DESTDIR)$(PACKAGE_LOCALE_DIR)/$$i/LC_MESSAGES/gnsu.mo po/$$i.po; \
	done


 .PHONY: mo updatepo pot clean install
