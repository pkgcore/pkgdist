#!/usr/bin/env bash
# Build and upload dist files to pypi on travis-ci.
#
# Note that this assumes TWINE_USERNAME and TWINE_PASSWORD are securely exported in
# order for twine to work properly.

set -ev

if [[ ${TRAVIS_PYTHON_VERSION} == "3.6" ]] && [[ -n ${TRAVIS_TAG} ]]; then
	# create sdist
	pip install -r requirements/dist.txt
	python setup.py sdist

	# create wheels
	cibuildwheel --output-dir dist

	# show the produced dist files
	ls dist/
	tar -ztf dist/*.tar.gz | sort

	# upload dist files to pypi
	twine upload dist/*
fi

exit 0
