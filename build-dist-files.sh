#!/usr/bin/env bash
# Build and upload dist files to pypi on travis-ci.
#
# Note that deploying to pypi assumes TWINE_USERNAME and TWINE_PASSWORD are
# securely exported to the environment in order for twine to work properly.

set -ev
shopt -s nullglob

# install deps
pip install -r requirements/dist.txt

# hack cibuildwheel to run docker in privileged mode in order to
# decrease the amount of test workarounds
CIBW_PATH=$(pip show cibuildwheel | grep Location | cut -d' ' -f 2)/cibuildwheel
sed -i "s:'CIBUILDWHEEL',:\0 '--privileged',:" "${CIBW_PATH}"/linux.py

# download binaries to update old centos 5 manylinux containers
DOWNLOAD_DIR="${HOME}/downloads"
for rpms in "${TRAVIS_BUILD_DIR}"/ci/cibuildwheel-bins/*; do
	arch=$(basename ${rpms})
	mkdir -p "${DOWNLOAD_DIR}"/${arch}
	while read url; do
		if [[ ! -f "${DOWNLOAD_DIR}/${arch}/$(basename ${url})" ]]; then
			wget -P "${DOWNLOAD_DIR}"/${arch} "${url}"
		fi
	done < "${rpms}"
done

# create sdist
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
