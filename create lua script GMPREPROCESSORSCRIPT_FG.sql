OPEN SCHEMA FG_SECURITY;
CREATE OR REPLACE LUA SCRIPT "GMPREPROCESSORSCRIPT_FG" () RETURNS ROWCOUNT AS
function gm_preprocessor_function_fg(sqltext)
--
-- SQL must start with SELECT or CREATE ...VIEW to be eligible (optionally with leading spaces)
-- otherwise return the original SQL
--

if ((string.find(string.upper(sqltext), '^%s*SELECT'))==nil 
and (string.find(string.upper(sqltext), '^%s*CREATE%s+.*VIEW'))==nil) 
then return sqltext
end 
--
-- check the roles assigned to the current user 
--
local conversions=query([[select table_name, altered_table_name from FG_SECURITY.FG_TABLE_NAMES]])
--
-- if the user has no permissions defined in the table then return the original SQL
--
if (#conversions==0) then return sqltext end
--

returntext=sqltext

--
-- Loop round the table names that need replacing
--

for i=1,#conversions do
this_table_name=conversions[i][1]
this_replacement=conversions[i][2]

--

      local tokens = sqlparsing.tokenize(returntext)
      for i=1,#tokens do
			if string.upper(tokens[i]) == 'FROM' then
				tokens[i]='FROM'
			end 
            if string.upper(tokens[i]) == 'OLAP.'..this_table_name then
                        tokens[i] = string.upper(tokens[i])
            end
        end

	returntext=table.concat(tokens)


-- replacements are only relevant in a JOIN (INNER JOIN, OUTER JOIN ... etc.) 
-- or in a FROM clause


from_clause_regexp='FROM%s+["]*[OLAP]*["]*[.]*["]*'..this_table_name..'["]*'
join_clause_regexp='JOIN%s+["]*[OLAP]*["]*[.]*["]*'..this_table_name..'["]*'
from_clause_replacement='FROM '..this_replacement..' '
join_clause_replacement='JOIN '..this_replacement..' '
returntext=string.gsub(returntext,from_clause_regexp,from_clause_replacement)
returntext=string.gsub(returntext,join_clause_regexp,join_clause_replacement)

end
--
-- 
-- return the preprocessed query text
return returntext
end
/