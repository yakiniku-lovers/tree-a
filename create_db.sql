CREATE TABLE users (
id integer primary key,
name varchar(50) not null unique,
status integer not null,
url text,
created_at default CURRENT_TIMESTAMP
);
