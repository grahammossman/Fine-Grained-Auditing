CREATE OR REPLACE LUA SCRIPT fg_security.wrap_sql_rewrite () 
RETURNS ROWCOUNT 
AS
import( 'fg_security.implement_fg_security', 'implement_fg_security') -- second parameter is just an alias 
sqlparsing.setsqltext(
implement_fg_security.rewrite_sql(sqlparsing.getsqltext()))
/

GRANT EXECUTE ON fg_security.wrap_sql_rewrite TO public;
