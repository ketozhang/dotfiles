.PHONY: all stow
ENVFILES := .env .global.env .secrets.env
DIRECTORIES := ${HOME}/.local/bin

all: stow check

stow: $(ENVFILES) $(DIRECTORIES)
	stow -v -t ${HOME} .

$(ENVFILES):
	touch $@

$(DIRECTORIES):
	mkdir -p $@

check: $(ENVFILES) $(DIRECTORIES)
	@for item in $(ENVFILES) $(DIRECTORIES); do \
		if [ -d "$$item" ]; then \
			fullpath="$$item"; \
		else \
			fullpath="${HOME}/$$item"; \
		fi; \
		if [ -e "$$fullpath" ]; then \
			printf "%.40s\033[0;32m%s\n\033[0m" "$$fullpath.........................................." "Exists"; \
		else \
			printf "%.40s\033[0;31m%s\n\033[0m" "$$fullpath.........................................." "Does not exist"; \
		fi \
	done
