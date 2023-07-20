#!/bin/bash

if [ -z "$1" ]
  then
    echo "Please supply path to the directory of exported org-roam-content"
fi

# Apply necessary patches for standalone operation
patch ../pages/index.tsx < index.tsx.patch
patch ../util/uniorg.tsx < uniorg.tsx.patch
patch ../components/Sidebar/Link.tsx < Link.tsx.patch
patch ../components/Sidebar/OrgImage.tsx < OrgImage.tsx.patch

# Copy previously exported content
cp $1/graphdata.json ../
cp -r $1/notes ../public/

# Run the Docker container
#
# Init packages
yarn
# Build static webserver
yarn build
# Export static webserver
yarn export -o standalone/out/

# Revert patches
patch -R ../pages/index.tsx < index.tsx.patch
patch -R ../util/uniorg.tsx < uniorg.tsx.patch
patch -R ../components/Sidebar/Link.tsx < Link.tsx.patch
patch -R ../components/Sidebar/OrgImage.tsx < OrgImage.tsx.patch
# Cleanup temporary data
rm  ../graphdata.json
rm -r ../public/notes
