.PHONY: system
system:
	sudo nixos-rebuild switch --flake ./systems/$$(hostname)
