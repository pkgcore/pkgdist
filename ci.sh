#!/usr/bin/env bash
# Initialize CI environment.

PKGDIST_PATH=${BASH_SOURCE[0]%/*}

set -ev
shopt -s nullglob

cp -Rv "${PKGDIST_PATH}"/requirements/* requirements/

# use versioned build deps for releases
if [[ ${TRAVIS_BRANCH} == "deploy" ]] || [[ -n ${TRAVIS_TAG} ]]; then
	if [[ -f requirements/pyproject.toml ]]; then
		cp -v requirements/pyproject.toml pyproject.toml
	fi
fi

exit 0
