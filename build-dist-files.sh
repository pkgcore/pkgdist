#!/usr/bin/env bash
# Build and upload dist files to pypi on travis-ci.
#
# Note that this assumes PYPI_USER and PYPI_PASSWORD are securely exported in
# order for twine to work properly.

set -ev

# make sure pip is installed for python3
curl https://raw.github.com/pypa/pip/master/contrib/get-pip.py | sudo python3

if [[ ${TRAVIS_PYTHON_VERSION} == "2.7" ]] && [[ -n ${TRAVIS_TAG} ]]; then
	# create sdist
	pip-3.3 install -r requirements.txt
	pip-3.3 install sphinx
	python3 setup.py sdist

	# create wheels
	pip install cibuildwheel
	cibuildwheel --output-dir dist

	# upload dist files to pypi
	pip install "twine>=1.8.1"
	twine upload dist/*
fi

exit 0
