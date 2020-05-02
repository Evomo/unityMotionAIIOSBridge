#!/bin/sh
set -e

FRAMEWORK="$1"
TAG="$2"
PROJECT_DIR=$(pwd)

# pump Tag/Version
podspec-bump -i ${TAG} -w
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString ${TAG}" "${PROJECT_DIR}/${FRAMEWORK}/Info.plist"

## lint and push pod to repo
# pod repo push bitbucket-evomopods ${FRAMEWORK}.podspec --allow-warnings

# create tag in source repo
git add -A && git commit -m "Release ${TAG}."
git tag "${TAG}"
git push --tags

#Thrid part: Create pod repo push
#### Instead create pod repo push -> add evomopod entry by ourself

cd ${PROJECT_DIR}
EVOMOPOD_PATH="../../../swift/frameworks/evomoPodsRelease/${FRAMEWORK}/${TAG}"

echo "Copy podspec to repo manual: ${EVOMOPOD_PATH}"

# create folder
mkdir "${EVOMOPOD_PATH}"

# copy podspec
cp "EvomoUnitySDK.podspec" "${EVOMOPOD_PATH}"

# commit
cd "${EVOMOPOD_PATH}"
git pull
git add --all
git commit -m "[Update] ${FRAMEWORK} (${TAG})"
git push

echo "Done"
