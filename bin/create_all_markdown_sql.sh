#!/bin/bash

ROOT_DIR=$(dirname `pwd`)

if [ "$(uname)" == "Darwin" ]; then
    GREP_REGEX_EXTEND=E
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    GREP_REGEX_EXTEND=P
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
    GREP_REGEX_EXTEND=P
fi

INPUT_DIR=$ROOT_DIR/input
OUTPUT_DIR=$ROOT_DIR/output
BIN_DIR=$ROOT_DIR/bin

# for i in `find $INPUT_DIR -type f -iregex ".*\.\(txt\|js\|cpp\|h\|php\)$"`; do
# for i in `find $INPUT_DIR -type f -iregex ".*\.js$"`; do

# 这种方式解决文件名带空格的问题
find $INPUT_DIR -type f -iregex ".*rocket.*\.\(text\)$" \
    -exec sh parse_markdown.sh {} \; \
    | grep -$GREP_REGEX_EXTEND "^insert into" \
    > $OUTPUT_DIR/markdown_data.sql

