-- use notes;

drop procedure if exists p_getline_with_article_id;

delimiter //

create procedure p_getline_with_article_id(article_id int, context_num int)
begin

    select * from t_articles 
        where t_articles.id = article_id;

    set @_start_id = 1;

    select id into @_start_id from t_notes
        where t_notes.article_id = article_id 
        limit 1; 

    select id as line_num, t_notes.article_id, text from t_notes 
        where t_notes.article_id = article_id
            and abs( t_notes.id - @_start_id ) <= context_num;

end//

delimiter ;
