#!/bin/bash

MYSQL_BIN=$(which mysql)
ROOT_DIR=$(dirname `pwd`)

# fe
# MYSQL_BIN=/home/hudamin/softwares/mysql/bin/mysql
# ROOT_DIR=/home/hudamin/projects/mynotes

TMP_SQL=$ROOT_DIR/__TMP.sql

if [ -e $TMP_SQL ]; then
    rm $TMP_SQL 
fi

for i in \
    "$ROOT_DIR/output/data.sql" \
    "$ROOT_DIR/sql/mysql_reset_master.sql" \
    ; do cat $i >> $TMP_SQL; done


$MYSQL_BIN -u root -p -D notes -A --default-character-set=utf8 < $TMP_SQL 
 
