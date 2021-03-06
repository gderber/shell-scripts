NAME=shell
VERSION=0.0.2
DESCRIPTION="Simple shell scripts"

SRCDIR=src
INSTALL_DIRS=`cd $(SRCDIR); find . -type d 2>/dev/null`
INSTALL_FILES=`cd $(SRCDIR); find . -type f 2>/dev/null`
DOC_FILES=*.md

PKG_DIR=pkg
PKG_NAME=$(NAME)-$(VERSION)
PKG=$(PKG_DIR)/$(PKG_NAME).tar.gz
SIG=$(PKG_DIR)/$(PKG_NAME).asc

PREFIX?=/usr/local
DOC_DIR=$(PREFIX)/share/doc/$(PKG_NAME)

pkg:
	mkdir -p $(PKG_DIR)

$(PKG): pkg
	git archive --output=$(PKG) --prefix=$(PKG_NAME)/ HEAD

build: $(PKG)

$(SIG): $(PKG)
	gpg --sign --detach-sign --armor $(PKG)

sign: $(SIG)

clean:
	rm -f $(PKG) $(SIG)

all: $(PKG) $(SIG)

test:

tag:
	git tag v$(VERSION)
	git push --tags

release: $(PKG) $(SIG) tag

install:
	@for dir in $(INSTALL_DIRS); \
	do \
		mkdir -p $(PREFIX)/$$dir; \
	done
	@for file in $(INSTALL_FILES); \
	do \
		cp src/$$file $(PREFIX)/$$file; \
	done
	mkdir -p $(DOC_DIR)
	cp -r $(DOC_FILES) $(DOC_DIR)/

uninstall:
	@for file in $(INSTALL_FILES); \
	do \
		rm -f $(PREFIX)/$$file; \
	done
	rm -rf $(DOC_DIR)


.PHONY: build sign clean test tag release install uninstall all
