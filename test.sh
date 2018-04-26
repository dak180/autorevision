#!/usr/bin/env bash

# This test script makes a number of assumptions about its environment
# and therefore is not meant to be portable or even to be run from
# outside Autorevision's repository.

# Prep
set -e
export VCS_EXTRA="test"
make tarball

# Configure
testPath="$(cd "$(dirname "$0")"; pwd -P)"
vers="$(./autorevision -fo ./autorevision.cache -s VCS_TAG | sed -e 's:v/::')"
tdir="autorevision-${vers}"
tarball="${tdir}.tgz"
tmpdir="$(mktemp -dqt autorevision)"


# Copy the tarball to a temp directory
cp -a "${tarball}" "${tmpdir}"

cd "${tmpdir}"

# Decompress
tar -xf "${tarball}"

cd "${tdir}"

# Poke it to see it does anything
make clean

# Test out of repo results.
cmp "autorevision.cache" "${testPath}/autorevision.cache"


# Test cache pollution.
cd "${testPath}"

./autorevision.sh -o "./autorevision.cache" -t "swift" -e "TEST"

cmp "autorevision.cache" "${tmpdir}/${tdir}/autorevision.cache"
