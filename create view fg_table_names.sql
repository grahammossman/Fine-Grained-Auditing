CREATE VIEW "FG_SECURITY"."FG_TABLE_NAMES"
as 
select table_name, '(SELECT * FROM OLAP.'||table_name||' WHERE '||replace(predicate,'<VALUES>', values_list)||')' altered_table_name 
from 
(select table_name, predicate, group_concat(''''||predicate_value||'''') values_list 
from fg_security.role_value rv join exa_user_role_privs p on (p.granted_role=rv.role_name)
group by 1,2
);
