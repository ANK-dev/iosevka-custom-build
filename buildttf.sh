#!/bin/bash

# Each plan present in the `private-build-plans.toml` will be included in this array
fonts=($(grep -oP '(?<=(?<!#|# )\[buildPlans\.)(?:\w|-+)*(?=])' private-build-plans.toml))

# Number of items in the `fonts` array
fontslength=${#fonts[@]}

for ((i=0; i<${fontslength}; i++));
do
    echo "Building ${fonts[$i]}... ($((i+1))/$((fontslength)))"
    # Builds only TTF variants: (Hinted and Unhinted)
    docker run --rm -it -v $(pwd):/build ankdev0/iosevka-custom-build ttf::${fonts[$i]}
done
