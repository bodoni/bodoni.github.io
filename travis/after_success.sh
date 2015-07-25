#!/bin/bash

set -ev

git config user.name "Travis CI"
git config user.email ""

if [ -z "${CRATE_NAME}" ]; then
  CRATE_NAME=$(echo ${TRAVIS_REPO_SLUG} | cut -d '/' -f 2 | sed 's/-/_/g')
fi

URL="${CRATE_NAME}/index.html"

HTML="<!DOCTYPE html>
<link rel='canonical' href='${URL}'>
<meta http-equiv='refresh' content='0; url=${URL}'>
<script>window.location='${URL}'</script>"

cargo doc ${CARGO_FLAGS}
echo "${HTML}" > target/doc/index.html

pip install ghp-import --user $USER
$HOME/.local/bin/ghp-import -m 'Update the documentation' -n target/doc

git push -qf https://${GITHUB_TOKEN}@github.com/${TRAVIS_REPO_SLUG}.git gh-pages
