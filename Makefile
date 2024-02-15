.PHONY: install

install:
	./install

tag:
	ansible-playbook bootstrap.yml --ask-become-pass --ask-vault-pass  --tags=$(tag)

dependencies:
	ansible-playbook bootstrap.yml --ask-become-pass --tags=dependencies

brew:
	ansible-playbook bootstrap.yml --tags=brew
