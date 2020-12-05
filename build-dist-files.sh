#!/usr/bin/env bash
# Build dist files to deploy to pypi for python projects.

PKGDIST_PATH=${BASH_SOURCE[0]%/*}

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
for urls in "${PKGDIST_PATH}"/cibuildwheel/*; do
	arch=$(basename ${urls})
	mkdir -p "${DOWNLOAD_DIR}"/${arch}
	while read url; do
		if [[ -n ${url} && ${url:0:1} != '#' ]]; then
			if [[ ! -f "${DOWNLOAD_DIR}/${arch}/$(basename ${url})" ]]; then
				wget -P "${DOWNLOAD_DIR}"/${arch} "${url}"
			fi
		fi
	done < "${urls}"
done

# create sdist
python setup.py sdist -v

# create wheels
cibuildwheel --output-dir dist

# show the produced dist files
ls dist/
tar -ztf dist/*.tar.gz | sort
sha512sum dist/*.tar.gz

exit 0
