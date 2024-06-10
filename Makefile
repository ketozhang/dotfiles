.PHONY: all stow
ENVFILES := .env .secrets.env

all: stow

stow: $(ENVFILES)
	stow -t ${HOME} .

$(ENVFILES):
	touch $@
