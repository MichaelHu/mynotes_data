-- use notes;

drop procedure if exists p_list_notes_with_context;

delimiter //

create procedure p_list_notes_with_context(from_id int, context_num int, direction int)
-- direction: -1 backwards, 1 forwards, 0 both directions
begin

    case direction
    when -1 then 
        select id as article_id, title, author, file_name, file_ext from t_articles 
            where from_id - id <= context_num and from_id - id >= 0;
    when 1 then 
        select id as article_id, title, author, file_name, file_ext from t_articles 
            where id - from_id <= context_num and id - from_id >= 0;
    else
        begin
        select id as article_id, title, author, file_name, file_ext from t_articles 
            where abs(id - from_id) <= context_num;
        end;
    end case;

end//

delimiter ;
