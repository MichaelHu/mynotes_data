show tables;
 
drop table if exists t_notes;
 
create table if not exists t_notes (
    id int auto_increment primary key,
    /*tag char(255) not null,*/
    article_id int not null,
    time datetime not null,
    text text
) character set utf8;


/*
set Names 'utf8';

insert into t_notes (article_id, time, text)
    values
(
    0,
    current_timestamp(),
    "Just a test!!"
);

select * from t_notes;
*/
