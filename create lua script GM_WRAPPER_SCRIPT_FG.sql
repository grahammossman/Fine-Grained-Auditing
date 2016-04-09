CREATE LUA SCRIPT "GM_WRAPPER_SCRIPT_FG" () RETURNS ROWCOUNT AS
import( 'olap.gmpreprocessorscript_fg', 'gmpreprocessorscript_fg') -- second parameter is just an alias 
sqlparsing.setsqltext(
gmpreprocessorscript_fg.gm_preprocessor_function_fg(sqlparsing.getsqltext()))
/
