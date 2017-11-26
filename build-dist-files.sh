#!/usr/bin/env bash
# Build and upload dist files to pypi on travis-ci.
#
# Note that deploying to pypi assumes TWINE_USERNAME and TWINE_PASSWORD are
# securely exported to the environment in order for twine to work properly.

set -ev

# create sdist
pip install -r requirements/dist.txt
python setup.py sdist

# create wheels
cibuildwheel --output-dir dist

# show the produced dist files
ls dist/
tar -ztf dist/*.tar.gz | sort

# only deploy tagged releases
if ${TRAVIS_SECURE_ENV_VARS} && [[ -n ${TRAVIS_TAG} ]]; then
	# upload dist files to pypi
	twine upload dist/*
fi

exit 0
