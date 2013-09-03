BEGIN {
    file_id = 0
    file_name = ""
    first_line = 0
}

/^@____filename:(.+)/ {
    first_line = 1

    file_id++
    file_name = substr($0, 15) 

    tmp_count = split(file_name, tmp_arr, /\./) 
    file_ext = tmp_arr[tmp_count]

    title = "null title" 

    # sprintf("head -1 \"%s\"", file_name) | getline title
    # close("/dev/stdin")

    # print tmp_arr[tmp_count]
    # getline file_id < "/dev/stdin"

    # sprintf("echo -n \"%s\" > aa.tmp && md5sum aa.tmp", file_name) | getline file_id
    # print file_id

    next
}

{

    if (1 == first_line){
        title = $0
        printf "insert into t_articles (file_name, file_ext, title, author) values (\"%s\", \"%s\", \"%s\", \"anonymous\" );\n", file_name, file_ext, title
        first_line = 0
        # print title
    }

    printf "insert into t_notes (article_id, time, text) values (\"%d\", current_timestamp(),\"%s\" );\n", file_id, $0

}
