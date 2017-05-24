#!/usr/bin/env bash
# Build and upload dist files to pypi on travis-ci.

set -ev

if [[ ${TRAVIS_PYTHON_VERSION} == "2.7" ]] && [[ -n ${TRAVIS_TAG} ]]; then
	# create sdist
	python3 -m pip install -r requirements.txt
	python3 setup.py sdist

	# create wheels
	pip install cibuildwheel
	cibuildwheel --output-dir dist

	# upload dist files to pypi
	pip install twine
	twine upload dist/*
fi

exit 0
