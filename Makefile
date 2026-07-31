.PHONY: test clean help install

all: test

test:
	@echo "Running cronminder tests..."
	@./tests/test_cronminder.sh

install:
	@./install.sh

clean:
	@echo "Cleaning temporary files..."
	@rm -f *.tmp

help:
	@echo "Available make targets:"
	@echo "  make test     - Run test suite"
	@echo "  make install  - Install / symlink plugin to Oh My Zsh custom plugins"
	@echo "  make clean    - Clean temporary files"
	@echo "  make help     - Print this help message"
