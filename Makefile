.PHONY: all stow
ENVFILES := .env .secrets.env
DIRECTORIES := ${HOME}/.local/bin

all: stow

stow: $(ENVFILES) $(DIRECTORIES)
	stow -t ${HOME} .

$(ENVFILES):
	touch $@

$(DIRECTORIES):
	mkdir -p $@
