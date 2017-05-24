#!/usr/bin/env bash
# Build and upload dist files to pypi on travis-ci.
#
# Note that this assumes PYPI_USER and PYPI_PASSWORD are securely exported in
# order for twine to work properly.

set -ev

if [[ ${TRAVIS_PYTHON_VERSION} == "2.7" ]] && [[ -n ${TRAVIS_TAG} ]]; then
	# create sdist
	python3 -m pip install -r requirements.txt
	python3 setup.py sdist

	# create wheels
	pip install cibuildwheel
	cibuildwheel --output-dir dist

	# upload dist files to pypi
	pip install "twine>=1.8.1"
	twine upload dist/*
fi

exit 0
