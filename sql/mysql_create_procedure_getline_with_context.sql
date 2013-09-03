-- use notes;

drop procedure if exists p_getline_with_context;

delimiter //

create procedure p_getline_with_context(line_num int, context_num int, direction int)
-- direction: -1 backwards, 1 forwards, 0 both directions
begin

    case direction
    when -1 then 
        select id as line_num, text from t_notes 
            where line_num - id <= context_num and line_num - id >= 0;
    when 1 then 
        select id as line_num, text from t_notes 
            where id - line_num <= context_num and id - line_num >= 0;
    else
        begin
        select id as line_num, text from t_notes 
            where abs(id - line_num) <= context_num;
        end;
    end case;

end//

delimiter ;
