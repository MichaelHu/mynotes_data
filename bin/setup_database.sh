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
    "$ROOT_DIR/sql/mysql_create_table_t_notes.sql" \
    "$ROOT_DIR/sql/mysql_create_table_t_articles.sql" \
    "$ROOT_DIR/output/data.sql" \
    "$ROOT_DIR/sql/mysql_create_procedure_search.sql" \
    "$ROOT_DIR/sql/mysql_create_procedure_getline_with_context.sql" \
    "$ROOT_DIR/sql/mysql_create_procedure_getline_with_article_id.sql" \
    "$ROOT_DIR/sql/mysql_create_procedure_list_notes_with_context.sql" \
    "$ROOT_DIR/sql/mysql_reset_master.sql" \
    ; do cat $i >> $TMP_SQL; done


$MYSQL_BIN -uroot -D notes -A --default-character-set=utf8 -S /tmp/mysql_3335.sock  < $TMP_SQL 
# $MYSQL_BIN -uroot -proot -D notes -A --default-character-set=utf8 < $TMP_SQL 
 
