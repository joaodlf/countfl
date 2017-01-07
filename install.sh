#!/bin/sh

install () {

set -eu
set -o pipefail

UNAME=$(uname)
if [ "$UNAME" != "Linux" -a "$UNAME" != "Darwin" -a "$UNAME" != "OpenBSD" ] ; then
    echo "Sorry, OS not supported: ${UNAME}. Download binary from https://github.com/joaodlf/countfl/releases"
    exit 1
fi

if [ "$UNAME" = "Darwin" ] ; then
  OSX_ARCH=$(uname -m)
  if [ "${OSX_ARCH}" = "x86_64" ] ; then
    PLATFORM="darwin-amd64"
  else
    echo "Sorry, architecture not supported: ${OSX_ARCH}. Download binary from https://github.com/joaodlf/countfl/releases"
    exit 1
  fi
elif [ "$UNAME" = "Linux" ] ; then
  LINUX_ARCH=$(uname -m)
  if [ "${LINUX_ARCH}" = "i686" ] ; then
    PLATFORM="linux-386"
  elif [ "${LINUX_ARCH}" = "x86_64" ] ; then
    PLATFORM="linux-amd64"
  else
    echo "Sorry, architecture not supported: ${LINUX_ARCH}. Download binary from https://github.com/joaodlf/countfl/releases"
    exit 1
  fi
elif [ "$UNAME" = "OpenBSD" ] ; then
    OPENBSD_ARCH=$(uname -m)
  if [ "${OPENBSD_ARCH}" = "amd64" ] ; then
      PLATFORM="openbsd-amd64"
  else
      echo "Sorry, architecture not supported: ${OPENBSD_ARCH}. Download binary from https://github.com/joaodlf/countfl/releases"
      exit 1
  fi

fi

LATEST=$(curl -s https://api.github.com/repos/joaodlf/countfl/tags | grep -Eo '"name":.*?[^\\]",'  | head -n 1 | sed 's/[," ]//g' | cut -d ':' -f 2)
URL="https://github.com/joaodlf/countfl/releases/download/$LATEST/countfl-$PLATFORM"
DEST=${DEST:-/usr/local/bin/countfl}

if [ -z $LATEST ] ; then
  echo "Error requesting. Download binary from https://github.com/joaodlf/countfl/releases"
  exit 1
else
  echo "Downloading Countfl binary from https://github.com/joaodlf/countfl/releases/download/$LATEST/countfl-$PLATFORM to $DEST"
  if curl -sL https://github.com/joaodlf/countfl/releases/download/$LATEST/countfl-$PLATFORM -o $DEST; then
    chmod +x $DEST
    echo "Countfl installation was successful"
  else
    echo "Installation failed. You may need elevated permissions."
  fi
fi
}

install
