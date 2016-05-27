PREFIX ?= /usr/local
DESTDIR ?= /
LIBEXEC_DIR ?= /usr/libexec
PACKAGE_LOCALE_DIR ?= /usr/share/locale

.PHONY: all
all: mo man

.PHONY: mo
mo:
	for i in `ls po/*.po`; do \
		msgfmt $$i -o `echo $$i | sed "s/\.po//"`.mo; \
	done

.PHONY: updatepo
updatepo:
	for i in `ls po/*.po`; do \
		msgmerge -UNs $$i po/gnsu.pot; \
	done

.PHONY: pot
pot:
	xgettext -L python -o po/gnsu.pot src/gnsu-askpass

.PHONY: man
man:
	txt2tags -o man/gnsu.man man/gnsu.t2t

.PHONY: clean
clean:
	rm -f po/*.mo
	rm -f po/*.po~
	rm -f man/gnsu.man

.PHONY: install
install: install-gnsu install-mo install-man

.PHONY: install-gnsu
install-gnsu:
	install -Dm 755 src/gnsu $(DESTDIR)/$(PREFIX)/bin/gnsu
	sed -i "s|^LIBEXECDIR=.*|LIBEXECDIR=$(LIBEXEC_DIR)|" $(DESTDIR)/$(PREFIX)/bin/gnsu
	install -Dm 755 src/gnsu-helper $(DESTDIR)/$(LIBEXEC_DIR)/gnsu-helper
	install -Dm 755 src/gnsu-askpass $(DESTDIR)/$(LIBEXEC_DIR)/gnsu-askpass
	install -Dm 644 src/gnsu-askpass.glade $(DESTDIR)/$(PREFIX)/share/gnsu/gnsu-askpass.glade

.PHONY: install-mo
install-mo:
	for i in `ls po/*.po | sed 's/.po//' | xargs -n1 basename` ;do \
		if [ ! -d $(DESTDIR)$(PACKAGE_LOCALE_DIR)/$$i/LC_MESSAGES ]; then \
			mkdir -p $(DESTDIR)$(PACKAGE_LOCALE_DIR)/$$i/LC_MESSAGES; \
		fi;\
	   	msgfmt -o $(DESTDIR)$(PACKAGE_LOCALE_DIR)/$$i/LC_MESSAGES/gnsu.mo po/$$i.po; \
	done

.PHONY: install-man
install-man:
	install -Dm 644 man/gnsu.man $(DESTDIR)/$(PREFIX)/man/man8/gnsu.8

.PHONY: transifex
transifex:
	tx pull -a

.PHONY: tx-pull
tx-pull:
	tx pull -a
	@for i in `ls po/*.po`; do \
		msgfmt --statistics $$i 2>&1 | grep "^0 translated" > /dev/null \
			&& rm $$i || true; \
	done
	@rm -f messages.mo

.PHONY: tx-pull-f
tx-pull-f:
	tx pull -a -f
	@for i in `ls po/*.po`; do \
		msgfmt --statistics $$i 2>&1 | grep "^0 translated" > /dev/null \
			&& rm $$i || true; \
	done
	@rm -f messages.mo

.PHONY: stat
stat:
	@for i in `ls po/*.po`; do \
		echo "Statistics for $$i:"; \
		msgfmt --statistics $$i 2>&1; \
		echo; \
	done
	@rm -f messages.mo

