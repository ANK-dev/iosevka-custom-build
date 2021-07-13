iosevka-custom-build (Docker)
=============================

This directory contains the build plans for building a custom version of the Iosevka font.

First, customize the `private-build-plans.toml` with your custom parameters.  
These can be obtained by using the font builder in <https://typeof.net/Iosevka/customizer>

Then either use the **Auto** or **Manual** build method.

Auto build
----------

Run the `buildimage.sh` script, then run either the `buildall.sh` or the `buildttf.sh` script.  
The font files of each plan defined in the `private-build-plans.toml` file will be built in sequence.

Manual build
------------

Build the image from the `Dockerfile` by running

```
docker build -t ankdev0/iosevka-custom-build .
```

Then run a docker image in this directory with the following command:

```
docker run --rm -it -v $(pwd):/build ankdev0/iosevka-build-new <contents>::<plan-name>
```

where `<contents>` can be one of the following:

- `contents::<plan-name>` : TTF (Hinted and Unhinted), WOFF(2) and Web font CSS;
- `ttf::<plan-name>` : TTF (Hinted and Unhinted);
- `ttf-unhinted::<plan-name>` : Unhinted TTF only;
- `webfont::<plan-name>` : Web fonts only (CSS + WOFF2);
- `woff2::<plan-name>` : WOFF2 only.

and `<plan-name>` is the name of a plan defined in your `private-build-plans.toml`.

The custom font will be built in the `./dist/` directory.

