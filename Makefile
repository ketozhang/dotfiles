.PHONY: all stow agents
ENVFILES := .env .global.env .secrets.env
DIRECTORIES := ${HOME}/.local/bin

all: stow agents check

stow: $(ENVFILES) $(DIRECTORIES)
	stow -v -t ${HOME} .

agents: stow
	mkdir -p ${HOME}/.codex ${HOME}/.claude
	@# Codex reads ~/.codex/AGENTS.md
	@if [ ! -e ${HOME}/.codex/AGENTS.md ]; then \
		ln -sv ${HOME}/.agents/AGENTS.md ${HOME}/.codex/AGENTS.md; \
	elif [ "$$(readlink ${HOME}/.codex/AGENTS.md)" != "${HOME}/.agents/AGENTS.md" ]; then \
		echo "Skipping ${HOME}/.codex/AGENTS.md: exists and is not a link to ~/.agents/AGENTS.md"; \
	fi
	@# Claude Code imports it from ~/.claude/CLAUDE.md
	@grep -qxF '@~/.agents/AGENTS.md' ${HOME}/.claude/CLAUDE.md 2>/dev/null || \
		echo '@~/.agents/AGENTS.md' >> ${HOME}/.claude/CLAUDE.md

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
