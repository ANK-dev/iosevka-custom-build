.PHONY: nerdttf ttf all dockerimage clean cleanall
.SILENT: nerdttf ttf all dockerimage
.ONESHELL: nerdttf ttf all dockerimage

SHELL := /bin/bash

# Each plan present in the `private-build-plans.toml` will be included in this array
PLANS := $(shell grep -oP '(?<=(?<!#|# )\[buildPlans\.)(?:\w|-+)*(?=])' private-build-plans.toml)

nerdttf: dockerimage
	for plan in $(PLANS); do
		ttfdir="$$(pwd)/dist/$$plan/ttf"

		echo "Building $$plan..."
		# Builds only TTF variants: (Hinted and Unhinted)
		docker run --rm -it -v $$(pwd):/build iosevka-custom-build ttf::$$plan

		if [ $$? -ne 0 ]; then
			# Patches font with nerdpatcher for Nerd Fonts symbols
			echo
			echo "Adding Nerd Fonts symbols for $$plan"
			docker run --rm --pull=always -v $$ttfdir:/in -v $$ttfdir/nerdpatch:/out nerdfonts/patcher -cs --progressbars --careful
		fi

	done

ttf: dockerimage
	for plan in $(PLANS); do
		echo "Building $$plan..."
		# Builds only TTF variants: (Hinted and Unhinted)
		docker run --rm -it -v $$(pwd):/build iosevka-custom-build ttf::$$plan
	done

all: dockerimage
	for plan in $(PLANS); do
		echo "Building $$plan..."
		# Builds only TTF variants: (Hinted and Unhinted)
		docker run --rm -it -v $$(pwd):/build iosevka-custom-build contents::$$plan
	done

dockerimage:
	docker_err_msg=$$(docker 2>&1);
	if [ $$? -ne 0 ]; then
		echo "$$docker_err_msg"
		exit 1;
	fi

	if [ "$$(docker images -q iosevka-custom-build:latest 2> /dev/null)" = "" ]; then
		docker build -t iosevka-custom-build:latest ./dockerfiles/
	fi

clean:
	sudo rm -rf dist/

cleanall: dockerimage
	sudo rm -rf dist/
	docker rmi -f iosevka-custom-build:latest
