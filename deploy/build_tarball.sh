#!/bin/bash

USAGE_STRING="USAGE: build_tarball.sh {VERSION_TAG}"

VERSION=$1
if [ -z "${VERSION}" ]; then
	echo "ERROR: Need a version number!" >&2
	echo "${USAGE_STRING}" >&2
	exit 1
fi

# Variables
WORK_DIRECTORY=app-v"${VERSION}"
TARBALL_FILE="${WORK_DIRECTORY}".tar.gz

# Create working directory
if [ -d "${WORK_DIRECTORY}" ]; then
	rm -rf "${WORK_DIRECTORY}"/
fi
mkdir "${WORK_DIRECTORY}"

# Cleanup tarball file
if [ -f "wheels/wheels" ]; then
	rm "${TARBALL_FILE}"
fi

# Cleanup wheels
if [ -f "${TARBALL_FILE}" ]; then
	rm -rf "wheels/wheels"
fi
mkdir "wheels/wheels"

# Copy app files to the working directory
cp -a ../project/app.py ../project/requirements.txt ../project/run.sh ../project/test.py "${WORK_DIRECTORY}"/

# remove .DS_Store and .pyc files
find "${WORK_DIRECTORY}" -type f -name '*.pyc' -delete
find "${WORK_DIRECTORY}" -type f -name '*.DS_Store' -delete

# Add wheel files
cp ./"${WORK_DIRECTORY}"/requirements.txt ./wheels/requirements.txt
cd wheels
docker build -t docker-python-wheel .
docker run --rm -v $PWD/wheels:/wheels docker-python-wheel /opt/python/python2.7/bin/python -m pip wheel --wheel-dir=/wheels -r requirements.txt
mkdir ../"${WORK_DIRECTORY}"/wheels
cp -a ./wheels/. ../"${WORK_DIRECTORY}"/wheels/
cd ..

# Add python interpreter
cp ./Python-2.7.14.tar.xz ./${WORK_DIRECTORY}/
cp ./get-pip.py ./${WORK_DIRECTORY}/

# Add pm2 process manager
cp ./pm2-2.9.1.tar.gz ./${WORK_DIRECTORY}/

# Make tarball
tar -cvzf "${TARBALL_FILE}" "${WORK_DIRECTORY}"/

# Cleanup working directory
rm -rf "${WORK_DIRECTORY}"/
