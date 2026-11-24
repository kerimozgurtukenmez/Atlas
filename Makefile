# Installs what `cargo build --release` produces, plus the desktop entry and
# icon. Cargo does the building; this only knows where files go.

PREFIX ?= /usr
DESTDIR ?=
BINDIR = $(DESTDIR)$(PREFIX)/bin
DATADIR = $(DESTDIR)$(PREFIX)/share
CARGO ?= cargo

.PHONY: all install uninstall clean

all: target/release/mochifile

target/release/mochifile:
	$(CARGO) build --release --locked

install: target/release/mochifile
	install -Dm755 target/release/mochifile $(BINDIR)/mochifile
	install -Dm644 assets/mochifile.desktop $(DATADIR)/applications/mochifile.desktop
	install -Dm644 assets/atlas.svg $(DATADIR)/icons/hicolor/scalable/apps/mochifile.svg
	install -Dm644 assets/atlas.svg $(DATADIR)/pixmaps/mochifile.svg

uninstall:
	rm -fv $(BINDIR)/mochifile \
		$(DATADIR)/applications/mochifile.desktop \
		$(DATADIR)/icons/hicolor/scalable/apps/mochifile.svg \
		$(DATADIR)/pixmaps/mochifile.svg

clean:
	$(CARGO) clean
