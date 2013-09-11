#!/bin/bash

ROOT_DIR=$(dirname `pwd`)

INPUT_DIR=$ROOT_DIR/input
OUTPUT_DIR=$ROOT_DIR/output
BIN_DIR=$ROOT_DIR/bin

if [ -e $INPUT_DIR/__TMP.tmptxt ]; then
    rm -f $INPUT_DIR/__TMP.tmptxt
fi

# for i in `find $INPUT_DIR -type f -iregex ".*\.\(txt\|js\|cpp\|h\|php\)$"`; do
# for i in `find $INPUT_DIR -type f -iregex ".*\.js$"`; do

# 这种方式解决文件名带空格的问题
# find $INPUT_DIR -type f -iregex ".*\.\(txt\|js\|cpp\|h\|php\)$" \

find $INPUT_DIR -type f -follow \( \
    -iregex ".*\.txt$" \
    -or -iregex ".*\.text$" \
    -or -iregex ".*\.php$" \
    -or -iregex ".*\.js$" \
    -or -iregex ".*\.h$" \
    -or -iregex ".*\.cpp$" \
    \) \
    -exec sh cat_file.sh {} >> $INPUT_DIR/__TMP.tmptxt \;

sh $BIN_DIR/create_sql.sh $INPUT_DIR/__TMP.tmptxt $OUTPUT_DIR/data.sql 
