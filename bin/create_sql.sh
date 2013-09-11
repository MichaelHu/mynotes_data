#!/bin/bash

# Usage: sh create_sql.sh input_file output_file

INPUT=$1
OUTPUT=$2

if [ "$(uname)" == "Darwin" ]; then
    SED_REGEX_EXTEND=E
    GREP_REGEX_EXTEND=E
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    SED_REGEX_EXTEND=r
    GREP_REGEX_EXTEND=P
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
    SED_REGEX_EXTEND=r
    GREP_REGEX_EXTEND=P
fi

# 1. 替换可能出问题的全角字符
# 2. 反斜线，双引号转义
# 3. 滤掉空行
# 4. 格式化输出
# 5. 过滤茶杯字符: ERROR 1366 (HY000) at line 4508: Incorrect string value: '\xF0\x9F\x8D\xBA  ...' for column 'text' at row 1
cat $INPUT \
    | sed -$SED_REGEX_EXTEND -e "s/、/ & /g" \
    | sed -$SED_REGEX_EXTEND -e "s/！/ & /g" \
    | sed -$SED_REGEX_EXTEND -e "s/，/ & /g" \
    | sed -$SED_REGEX_EXTEND -e "s/：/ & /g" \
    | sed -$SED_REGEX_EXTEND -e "s/。/ & /g" \
    | sed -$SED_REGEX_EXTEND -e "s/🍺 //g" \
    | sed -$SED_REGEX_EXTEND -e "s/[\"\\]/\\\\&/g" \
    | grep -${GREP_REGEX_EXTEND}v "^$" \
    > $OUTPUT.tmp 

awk -f format_sql.awk $OUTPUT.tmp \
    > $OUTPUT

rm $OUTPUT.tmp 

