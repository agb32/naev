ACLOCAL_AMFLAGS = --install -I m4

SUBDIRS = lib src
DIST_SUBDIRS = lib src

if HAVE_UTILS
SUBDIRS += utils
endif # HAVE_NLS
if HAVE_NLS
SUBDIRS += po
DIST_SUBDIRS += po
endif # HAVE_NLS

appicondir = $(datadir)/pixmaps
appicon_DATA = extras/logos/naev.png
Graphicsdir = $(datadir)/applications
Graphics_DATA = naev.desktop
appdatadir = $(datadir)/appdata
appdata_DATA = naev.appdata.xml
dist_pkgdata_DATA = naev-confupdate.sh

dist_man6_MANS = naev.6
dist_doc_DATA = AUTHORS README TODO LICENSE

DATA_ARCHIVE = ndata.zip
if HAVE_UTILS
MKSPR      = utils/mkspr/mkspr$(EXEEXT)
endif
NAEV	     = $(PACKAGE)$(EXEEXT)

VERSIONFILE = VERSION
LANGUAGEFILE = $(top_srcdir)/dat/LANGUAGES

EXTRA_DIST = build/config.rpath LICENSE extras naev.desktop naev.appdata.xml
CLEANFILES = $(DATA_ARCHIVE) $(NAEV) $(VERSIONFILE) $(LANGUAGEFILE)

if HAVE_NLS
XMLBASE     = $(wildcard dat/*.xml)
XMLOUTFITS  = $(wildcard dat/outfits/*/*.xml)
XMLSHIPS    = $(wildcard dat/ships/*.xml)
XMLFILES    = $(XMLBASE) $(XMLSHIPS) $(XMLOUTFITS)
TRANSLATIONITS = $(top_srcdir)/po/translation.its
XMLPOT      = $(top_srcdir)/po/xml.pot
CLEANFILES += $(XMLPOT)
endif # HAVE_NLS

.PHONY: pot docs utils help install-ndata soundtrack

all-local: $(NAEV) pot $(VERSIONFILE)

if HAVE_NLS
$(XMLPOT): $(XMLFILES) $(TRANSLATIONITS)
	$(ITSTOOL) -i $(TRANSLATIONITS) $(XMLFILES) > $@
	@echo "ITSTOOL $@"

if HAVE_DATA
pot: $(LANGUAGEFILE) $(XMLPOT) $(NAEV)
	$(MAKE) -C po $(PACKAGE).pot

$(LANGUAGEFILE): po/LINGUAS
	tail -n +2 $< > $@
else # HAVE_DATA
pot:
endif # HAVE_DATA

else # HAVE_NLS
pot: $(XMLPOT) $(NAEV)
	@echo "***"
	@echo "*** You must have NLS enabled to compile translation files"
	@echo "***"
endif # HAVE_NLS

$(NAEV):
	@echo "  LN    $(NAEV)"
	$(LN_S) "src/$(NAEV)" "$(NAEV)"

$(VERSIONFILE): src/config.h
	echo $(VERSION) > $@

if HAVE_UTILS
utils: $(MKSPR)

$(MKSPR):
	$(MAKE) -C utils/mkspr
else # HAVE_UTILS
utils:
endif # HAVE_UTILS

if HAVE_DATA
$(DATA_ARCHIVE): $(VERSIONFILE)
	@echo " ZIP   $(DATA_ARCHIVE)"
	cd "$(top_srcdir)" && \
    zip -0r "$(abs_top_builddir)/$(DATA_ARCHIVE)" AUTHORS $(VERSIONFILE) naev-confupdate.sh dat/
else # HAVE_DATA
$(DATA_ARCHIVE):
	@echo "***"
	@echo "*** You must clone the full git repo to create $(DATA_ARCHIVE)"
	@echo "***"
	@false
endif # HAVE_DATA

install-ndata: $(DATA_ARCHIVE)
	ndata="$(DESTDIR)$(ndata_path)"; \
	dir=$$(echo "$$ndata" | sed 's/\(.*\)[\/\\].*/\1/'); \
	echo " $(MKDIR_P) '$$dir'"; \
	$(MKDIR_P) "$$dir"; \
	echo " $(INSTALL_DATA) -c '$(DATA_ARCHIVE)' '$$ndata'"; \
	$(INSTALL_DATA) -c "$(DATA_ARCHIVE)" "$$ndata"

install-data-hook:
	if test -e $(top_srcdir)/dat && test -e $(top_srcdir)/dat/gfx; then \
	  $(MAKE) install-ndata; \
	fi

uninstall-hook:
	echo " rm -rf '$(DESTDIR)$(pkgdatadir)'"; \
	echo " rm -rf '$(docdir)'"; \
	rm -rf "$(DESTDIR)$(pkgdatadir)"
	rm -rf "$(docdir)"

docs:
	$(MAKE) -C docs

soundtrack: naev-$(VERSION)-soundtrack.zip

naev-$(VERSION)-soundtrack.zip: utils/soundtrack.py dat/snd/soundtrack.yaml
	./utils/soundtrack.py

help:
	@echo "Possible targets are:"
	@echo "        all - builds everything"
	@echo "  ndata.zip - creates the ndata file"
	@echo "       docs - creates the doxygen documentation"
	@echo " soundtrack - creates the soundtrack zip file"
	@echo "      clean - removes binaries and object files"
	@echo "    install - installs naev"
	@echo "  uninstall - removes previously installed files"
	@echo "  dist-gzip - creates a source tarball with gzip compression"
	@echo " dist-bzip2 - creates a source tarball with bzip2 compression"
	@echo "  distcheck - checks if the created tarball works properly"
	@echo "  distclean - does clean and removes files created by configure"
