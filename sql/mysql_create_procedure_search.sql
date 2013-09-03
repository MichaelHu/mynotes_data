-- use notes;

drop procedure if exists p_search;

delimiter //
-- 用text代替char，能保留关键词后面的空白字符
-- create procedure p_search(key_words char(128), from_index int, count_num int, context_num int)
create procedure p_search(key_words text, from_index int, count_num int, context_num int)
begin

    -- 关键词个数
    declare key_word_count int default 1;

    -- 用text代替char，能保留关键词后面的空白字符
    -- declare key_word_1 char(32);
    -- declare key_word_2 char(32);
    -- declare key_word_3 char(32);
    declare key_word_1 text;
    declare key_word_2 text;
    declare key_word_3 text;

    -- 切词分隔符
    declare s_separator char(32) default ' + ';

    -- 起始字符串下标
    declare f int default 1;
    -- 空白也作为查询条件
    -- set key_words = trim(key_words);

    -- 切词
    while locate(s_separator, key_words, f) > 0 do
        if key_word_count = 1 then
            set key_word_1 = substr(key_words, f, locate(s_separator, key_words, f) - f);
        elseif key_word_count = 2 then
            set key_word_2 = substr(key_words, f, locate(s_separator, key_words, f) - f);
        else
            set key_word_3 = substr(key_words, f, locate(s_separator, key_words, f) - f);
        end if;
        set f = locate(s_separator, key_words, f) + 3;
        set key_word_count = key_word_count + 1;
    end while;

    if length(substr(key_words, f)) > 0 then
        if key_word_count = 1 then
            set key_word_1 = substr(key_words, f);
        elseif key_word_count = 2 then
            set key_word_2 = substr(key_words, f);
        else
            set key_word_3 = substr(key_words, f);
        end if;
    end if;

    -- 输出关键词
    if key_word_count = 1 then
        select key_word_1;
    elseif key_word_count = 2 then
        select key_word_1, key_word_2;
    else
        select key_word_1, key_word_2, key_word_3;
    end if;


    -- 查询
    -- drop table tmp_tab;
    if key_word_count >= 1 then
        create temporary table if not exists tmp_tab_1 (
                idx int auto_increment primary key,
                id int not null
            ) 
            select id from t_notes where instr(t_notes.text, key_word_1) > 0;
    end if;

    if key_word_count >= 2 then
        create temporary table if not exists tmp_tab_2 (
                idx int auto_increment primary key,
                id int not null
            ) 
            select id from t_notes where instr(t_notes.text, key_word_2) > 0;
    end if;

    if key_word_count >= 3 then
        create temporary table if not exists tmp_tab_3 (
                idx int auto_increment primary key,
                id int not null
            ) 
            select id from t_notes where instr(t_notes.text, key_word_3) > 0;
    end if;

    -- 合并
    if key_word_count = 1 then

        create temporary table if not exists tmp_tab (
                idx int auto_increment primary key,
                id int not null
            )
            select distinct tmp_tab_1.id from tmp_tab_1;

    elseif key_word_count = 2 then

        create temporary table if not exists tmp_tab (
                idx int auto_increment primary key,
                id int not null
            )
            select distinct tmp_tab_1.id from tmp_tab_1
                join (tmp_tab_2) on (
                    abs(tmp_tab_1.id - tmp_tab_2.id) <= context_num
                );

    else

        create temporary table if not exists tmp_tab (
                idx int auto_increment primary key,
                id int not null
            )
            select distinct tmp_tab_1.id from tmp_tab_1
                join (tmp_tab_2, tmp_tab_3) on (
                    -- line1为中间行
                    abs(tmp_tab_1.id - tmp_tab_2.id) <= context_num
                    and abs(tmp_tab_1.id - tmp_tab_3.id) <= context_num

                    or

                    -- line2为中间行
                    abs(tmp_tab_1.id - tmp_tab_2.id) <= context_num
                    and abs(tmp_tab_2.id - tmp_tab_3.id) <= context_num

                    or

                    -- line3为中间行
                    abs(tmp_tab_1.id - tmp_tab_3.id) <= context_num
                    and abs(tmp_tab_2.id - tmp_tab_3.id) <= context_num
                );

    end if;

    -- 结果总数
    select count(*) as count from tmp_tab;

    -- 按起始索引与指定数目返回
    select distinct t_notes.id as line_num, t_notes.article_id, t_notes.text from t_notes 
        join (tmp_tab) on (
            abs(tmp_tab.id - t_notes.id) <= context_num
            and tmp_tab.idx >= from_index
            and tmp_tab.idx - from_index < count_num
        );

end//
delimiter ;
