#!/bin/bash

if [ "$(uname)" == "Darwin" ]; then
    GREP_REGEX_EXTEND=E
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    GREP_REGEX_EXTEND=P
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
    GREP_REGEX_EXTEND=P
fi

_file=$1

# only for utf-8 or ascii
if file --mime $_file | grep -$GREP_REGEX_EXTEND 'charset=(utf-8|us-ascii)' &>/dev/null
then

echo "@____filename:$_file"
cat "$_file"
echo

fi
