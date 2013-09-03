show tables;
 
drop table if exists t_markdown_articles;
 
create table if not exists t_markdown_articles (
    id int auto_increment primary key,
    title text not null,
    tag char(255),
    author char(255),
    time datetime,
    content mediumtext
) character set utf8;


