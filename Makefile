.PHONY: all stow
ENVFILES := .env .secrets.env
DIRECTORIES := ${HOME}/.local/bin

all: stow check

stow: $(ENVFILES) $(DIRECTORIES)
	stow -t ${HOME} .

$(ENVFILES):
	touch $@

$(DIRECTORIES):
	mkdir -p $@

check: $(ENVFILES) $(DIRECTORIES)
	@for item in $(ENVFILES) $(DIRECTORIES); do \
		if [ -e "$$item" ]; then \
			printf "%.40s\033[0;32m%s\n\033[0m" "$$item.........................................." "Exists"; \
		else \
			printf "%.40s\033[0;31m%s\n\033[0m" "$$item.........................................." "Does not exist"; \
		fi \
	done