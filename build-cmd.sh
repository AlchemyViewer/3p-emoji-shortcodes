#!/usr/bin/env bash

# turn on verbose debugging output for parabuild logs.
exec 4>&1; export BASH_XTRACEFD=4; set -x
# make errors fatal
set -e
# complain about unset env variables
set -u

# check autobuild is around or fail
if [ -z "$AUTOBUILD" ] ; then
    exit 1
fi

STAGING_DIR="$(pwd)"
TOP_DIR="$(dirname "$0")"
SRC_DIR="${TOP_DIR}/emojibase"
VERSION_PATH="${STAGING_DIR}/VERSION.txt"

if [ "$OSTYPE" = "cygwin" ] ; then
    autobuild="$(cygpath -u $AUTOBUILD)"
    VERSION_PATH="$(cygpath -w $VERSION_PATH)"
else
    autobuild="$AUTOBUILD"
fi

python "$TOP_DIR"/gen_emoji_characters.py "$SRC_DIR"/packages/data stage/xui

mkdir -p "$STAGING_DIR"/LICENSES
cp "$SRC_DIR"/LICENSE "$STAGING_DIR"/LICENSES/emojibase-license.txt

# Read the EmojiBase version from core package.json file and use it to build this package version
python "$TOP_DIR"/get_version.py "${SRC_DIR}/packages/core/package.json" ${VERSION_PATH} ${AUTOBUILD_BUILD_ID:=0}
