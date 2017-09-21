#!/usr/bin/env bash
# Build and upload dist files to pypi on travis-ci.
#
# Note that this assumes TWINE_USERNAME and TWINE_PASSWORD are securely exported in
# order for twine to work properly.

set -ev

# make sure pip is installed for python3
python3 --version
curl https://bootstrap.pypa.io/get-pip.py | sudo python3

if [[ ${TRAVIS_PYTHON_VERSION} == "2.7" ]] && [[ -n ${TRAVIS_TAG} ]]; then
	# create sdist
	sudo pip3 install -r requirements.txt
	sudo pip3 install sphinx
	python3 setup.py sdist

	# create wheels
	sudo pip install cibuildwheel
	cibuildwheel --output-dir dist

	# show the produced dist files
	ls dist/
	tar -ztf dist/*.tar.gz | sort

	# upload dist files to pypi
	sudo pip install "twine>=1.8.1"
	twine upload dist/*
fi

exit 0
