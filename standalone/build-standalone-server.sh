#!/bin/bash

set -eux

SCRIPTPATH="$( cd "$(dirname "$0")" || exit ; pwd -P )"
export SCRIPTPATH

export NODE_OPTIONS=--openssl-legacy-provider

if [ -z "$1" ]
  then
    echo "Please supply path to the directory of exported org-roam-content"
fi

# Apply necessary patches for standalone operation
patch "${SCRIPTPATH}"/../pages/index.tsx < "${SCRIPTPATH}"/index.tsx.patch
patch "${SCRIPTPATH}"/../util/uniorg.tsx < "${SCRIPTPATH}"/uniorg.tsx.patch
patch "${SCRIPTPATH}"/../components/Sidebar/Link.tsx < "${SCRIPTPATH}"/Link.tsx.patch
patch "${SCRIPTPATH}"/../components/Sidebar/OrgImage.tsx < "${SCRIPTPATH}"/OrgImage.tsx.patch
patch "${SCRIPTPATH}"/../components/Tweaks/Behavior/BehaviorPanel.tsx < "${SCRIPTPATH}"/BehaviorPanel.tsx.patch
patch "${SCRIPTPATH}"/../components/contextmenu.tsx < "${SCRIPTPATH}"/contextmenu.tsx.patch

# Copy previously exported content
cp $1/graphdata.json "${SCRIPTPATH}"/../
cp -r $1/notes "${SCRIPTPATH}"/../public/

# Run the Docker container

pushd "${SCRIPTPATH}"
# Init packages
yarn
# Build static webserver
yarn build
# Remove previous export.
rm -rfv $1/out
# Export static webserver1
yarn export -o $1/out
popd

# Revert patches
patch -R "${SCRIPTPATH}"/../pages/index.tsx < "${SCRIPTPATH}"/index.tsx.patch
patch -R "${SCRIPTPATH}"/../util/uniorg.tsx < "${SCRIPTPATH}"/uniorg.tsx.patch
patch -R "${SCRIPTPATH}"/../components/Sidebar/Link.tsx < "${SCRIPTPATH}"/Link.tsx.patch
patch -R "${SCRIPTPATH}"/../components/Sidebar/OrgImage.tsx < "${SCRIPTPATH}"/OrgImage.tsx.patch
patch -R "${SCRIPTPATH}"/../components/Tweaks/Behavior/BehaviorPanel.tsx < "${SCRIPTPATH}"/BehaviorPanel.tsx.patch
patch -R "${SCRIPTPATH}"/../components/contextmenu.tsx < "${SCRIPTPATH}"/contextmenu.tsx.patch

# Cleanup temporary data
rm  "${SCRIPTPATH}"/../graphdata.json
rm -r "${SCRIPTPATH}"/../public/notes
