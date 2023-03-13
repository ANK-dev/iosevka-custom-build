#!/bin/sh

dir="$(pwd)/dist/iosevka-term-custom/ttf"

docker run --pull=always -v $dir:/in -v $dir/nerdpatch_windows:/out nerdfonts/patcher -csw --progressbars --careful
docker run --pull=always -v $dir:/in -v $dir/nerdpatch_unix:/out nerdfonts/patcher -cs --progressbars --careful
