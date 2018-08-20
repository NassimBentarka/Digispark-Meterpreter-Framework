PREFIX=/usr
MANDIR=$(PREFIX)/share/man
BINDIR=$(PREFIX)/bin

all:
	@echo "Run 'make install' for installation."
	@echo "Run 'make uninstall' for uninstallation."

install:
	@cp -R . $(DESTDIR)/etc/digispark-msf
	@chmod +x $(DESTDIR)/etc/digispark-msf/main.rb
	@ln -s $(DESTDIR)/etc/digispark-msf/main.rb $(DESTDIR)$(BINDIR)/digispark-msf
	@install -Dm644 README.md $(DESTDIR)$(PREFIX)/share/doc/digispark-msf/README.md
	@echo "Installed with success, it can be run by this command: digispark-msf"

uninstall:
	@rm -rf $(DESTDIR)/etc/digispark-msf
	@rm -f $(DESTDIR)$(BINDIR)/digispark-msf
	@rm -f $(DESTDIR)$(PREFIX)/share/doc/digispark-msf/README.md
	@echo "Uninstalled with success"

