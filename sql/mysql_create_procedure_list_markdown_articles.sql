-- use notes;

drop procedure if exists p_list_markdown_articles;

delimiter //

create procedure p_list_markdown_articles(_tag char(128))
begin

    select id as article_id, title, tag, author, time
        from t_markdown_articles 
        where locate(_tag, tag, 1) > 0; 

end//

delimiter ;


