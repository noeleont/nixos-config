.PHONY: system
system:
	sudo nixos-rebuild switch --flake ./systems/$$(hostname)

update:
	nix flake update --flake ./systems/$$(hostname)
