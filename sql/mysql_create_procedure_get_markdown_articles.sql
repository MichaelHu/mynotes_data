-- use notes;

drop procedure if exists p_get_markdown_articles;

delimiter //

create procedure p_get_markdown_articles(_title char(128))
begin

    select id as article_id, title, tag, author, time, content 
        from t_markdown_articles 
        where title = _title; 

end//

delimiter ;

