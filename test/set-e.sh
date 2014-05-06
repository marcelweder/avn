#!/bin/bash

typeset __abspath=$(cd ${0%/*} && echo $PWD/${0##*/})
typeset __dirname=`dirname "${__abspath}"`
typeset __tmp=`mktemp /tmp/avn-test.XXXXXX`
typeset __calls=""

set -e

# even with `set -e`, if `_avn` exits with a status of 1, the `cd` should still
# work, and both the before and after hooks should be invoked.
function _avn() {
  echo "$1" >> ${__tmp}
  exit 1
}

source "${__dirname}/helpers.sh"
source "${__dirname}/../bin/avn.sh"
cd "${__dirname}/examples/v0.11"
__calls=`echo $(cat ${__tmp})`

assertEqual `pwd` "${__dirname}/examples/v0.11"
assertEqual "before-cd after-cd" "${__calls}" || exit 1

rm ${__tmp}