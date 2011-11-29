#!/bin/sh

whoami
pwd
security list-keychains
#security unlock-keychain -p strausviame "~/Library/Keychains/login.keychain"
xcodebuild clean


PROJDIR=`pwd`
PROJECT_NAME=viame-iphone
TARGET_SDK="Default"
PROJECT_BUILDDIR="${PROJDIR}/build/Release-iphoneos"
TARGET_TEST_NAME="UnitTests"
BUILD_HISTORY_DIR="/Users/brad/Desktop"
DEVELOPPER_NAME="iPhone Developer: Brad Smith"
PROVISONNING_PROFILE="DeveloperProfile/PicBounce.mobileprovision"
APPLICATION_NAME="Picbounce2"
 
# compile project
echo Building Project
cd "${PROJDIR}"
xcodebuild -target "${PROJECT_NAME}" -configuration Release

#Check if build succeeded
if [ $? != 0 ]
then
  exit 1
fi

/usr/bin/xcrun -sdk iphoneos PackageApplication -v "${PROJECT_BUILDDIR}/${APPLICATION_NAME}.app" -o "${BUILD_HISTORY_DIR}/${APPLICATION_NAME}.ipa" --sign "${DEVELOPPER_NAME}" --embed "${PROVISONNING_PROFILE}"

