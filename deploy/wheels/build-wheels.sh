#!/bin/bash

set -e -x

# Compile wheels
"/opt/python/python2.7/bin/python -m pip" install -r requirements.txt
"/opt/python/python2.7/bin/python -m pip wheel" wheel -w wheels/

# Bundle external shared libraries into the wheels
for whl in wheelhouse/*.whl; do
  auditwheel repair "$whl" -w /wheelhouse/
done
