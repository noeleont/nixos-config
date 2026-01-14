HOSTNAME ?= $(shell hostname)
FLAKE ?= .#$(HOSTNAME)

.PHONY: system
system:
	sudo nixos-rebuild switch --flake $(FLAKE)

update:
	nix flake update --flake $(FLAKE)
