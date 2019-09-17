#!/usr/bin/env bash
# Initialize CI environment.

PKGDIST_PATH=${BASH_SOURCE[0]%/*}

set -ev
shopt -s nullglob

cp -Rv "${PKGDIST_PATH}"/requirements/* requirements/

requirements/pip.sh -rrequirements/ci.txt

# use git-based build deps for dev tests
if [[ ${TRAVIS_BRANCH} != "deploy" ]] && [[ -z ${TRAVIS_TAG} ]]; then
	if [[ -f requirements/pyproject-dev.toml ]]; then
		cp -v requirements/pyproject-dev.toml pyproject.toml
	fi
fi

exit 0
