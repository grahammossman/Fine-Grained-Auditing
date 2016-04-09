# Fine-Grained-Auditing
--
-- Current version 2016/04/26
-- Graham Mossman, EXASOL
--

The following objects implement a kind of fine-grained auditing (similar to Oracle's) in EXASOL.

This is a limited version that makes some assumptions about the SQL 
i.e. it does not pretend to be able to cope with all SQL statements.

For example, we assume that all object identifiers are case-independent and that the table that needs to be rewritten 
is in a schema called OLAP.

Installation

(1) Create a schema to contain these objects (I use FG_SECURITY)

(2) Create and populate the ROLE_VALUE table - this maps database ROLES to substitutions that need to be made

(3) Create the fg_table_names schema - this combines the ROLE_VALUE table with the database ROLES held by the current user

(4) Create the Lua scripts GMPREPROCESSORSCRIPT_FG - this contains the intelligence for substituting the table

(5) Create the Lua script GM_WRAPPER_SCRIPT_FG - this is a simple script for calling the main script.

Now you can activate fine grained auditing on your database by using :

alter session set sql_preprocessor_script=olap.gm_wrapper_script_fg;
or
alter system set sql_preprocessor_script=olap.gm_wrapper_script_fg;

You can turn it off with 

alter system set sql_preprocessor_script='';

I also attach a test script which shows the expected results when you run some test SQL with the pre-processor switched on.
