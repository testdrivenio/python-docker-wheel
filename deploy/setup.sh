#!/bin/bash

USAGE_STRING="USAGE: sh setup.sh {VERSION} {USERNAME}"

VERSION=$1
if [ -z "${VERSION}" ]; then
	echo "ERROR: Need a version number!" >&2
	echo "${USAGE_STRING}" >&2
	exit 1
fi

USERNAME=$2
if [ -z "${USERNAME}" ]; then
  echo "ERROR: Need a username!" >&2
  echo "${USAGE_STRING}" >&2
  exit 1
fi

FILENAME="app-v${VERSION}"
TARBALL="app-v${VERSION}.tar.gz"

# Untar the tarball
tar xvxf ${TARBALL}
cd $FILENAME

# Install python
tar xvxf Python-2.7.14.tar.xz
cd Python-2.7.14
./configure \
	--prefix=/home/$USERNAME/python2.7 \
	--with-zlib-dir=/home/$USERNAME/lib \
	--enable-optimizations
echo "Running MAKE =================================="
make
echo "Running MAKE INSTALL ==================================="
make install
echo "cd USERNAME/FILENAME ==================================="
cd /home/$USERNAME/$FILENAME

# Install pip and virtualenv
echo "python get-pip.py  ==================================="
/home/$USERNAME/python2.7/bin/python get-pip.py
echo "python -m pip install virtualenv  ==================================="
/home/$USERNAME/python2.7/bin/python -m pip install virtualenv

# Create and activate a new virtualenv
echo "virtualenv venv  ==================================="
/home/$USERNAME/python2.7/bin/virtualenv venv
echo "source activate  ==================================="
source venv/bin/activate

# Install python dependencies
echo "install wheels  ==================================="
pip install wheels/*
