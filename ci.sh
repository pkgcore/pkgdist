#!/usr/bin/env bash
# Initialize CI environment.

PKGDIST_PATH=${BASH_SOURCE[0]%/*}

set -ev
shopt -s nullglob

cp -Rv "${PKGDIST_PATH}"/requirements/* requirements/

"${PKGDIST_PATH}"/requirements/pip.sh -rrequirements/ci.txt

# use git-based build deps for non-tagged releases
if [[ -z ${TRAVIS_TAG} ]]; then
	cp -v requirements/pyproject-dev.toml pyproject.toml
fi

exit 0
