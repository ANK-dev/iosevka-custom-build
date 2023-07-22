iosevka-custom-build (Docker)
=============================

This directory contains the build plans for building a custom version of the Iosevka font.

First, customize the `private-build-plans.toml` with your custom parameters. \
These can be obtained by using the font builder in <https://typeof.net/Iosevka/customizer>

Then either use the **Auto** or **Manual** build method.

Auto build
----------

Run any of the following commands:

  - `make`: Unhinted TTF and hinted TTF patched with Nerd Fonts symbols
  - `make nerdttf`: same as `make` 
  - `make ttf`: unhinted and hinted TTF
  - `make all`: unhinted and hinted TTF, WOFF2 and Web Font CSS 

If not already present, a Docker image will be built and run for the build process. \
The font files of each plan defined in the `private-build-plans.toml` file will be built in sequence. \
The custom font will be built in the `./dist/` directory.

Manual build
------------

Build the image from the `Dockerfile` by running

```sh
docker build -t iosevka-custom-build:latest ./dockerfiles/
```

Then run a docker image in this directory with the following command:

```sh
docker run --rm -it -v $(pwd):/build iosevka-custom-build <contents>::<plan-name>
```

where `<contents>` can be one of the following:

- `contents::<plan-name>` : TTF (Hinted and Unhinted), WOFF(2) and Web font CSS;
- `ttf::<plan-name>` : TTF (Hinted and Unhinted);
- `ttf-unhinted::<plan-name>` : Unhinted TTF only;
- `webfont::<plan-name>` : Web fonts only (CSS + WOFF2);
- `woff2::<plan-name>` : WOFF2 only.

and `<plan-name>` is the name of a plan defined in your `private-build-plans.toml`.

The custom font will be built in the `./dist/` directory.

Cleanup
-------

Run the `make clean` command to delete the `dist/` directory and all its contents. \
Run the `make cleanall` command to both delete the `dist/` directory and remove the docker image.