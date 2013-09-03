show tables;
 
drop table if exists t_articles;
 
create table if not exists t_articles (
    id int auto_increment primary key,
    file_name char(255) not null,
    file_ext char(32) not null,
    title char(255) not null,
    author char(32)
) character set utf8;

/*
set Names 'utf8';
 
insert into t_articles (title, author)
    values
(
    "test title",
    "test author"
);

select * from t_articles;
*/
