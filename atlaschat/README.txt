If you already have atlaschat 2.4.2 installed then you only need to add this line in cl_expression.lua at line 886:

icon = icon:gsub( "decals/rendershadow", "icon16/user.png" )


In sv_sql.lua you need to replace this part at line 220:

if (atlaschat.sql.remote.address) then

with

local countLines = sql.Query( "SELECT count(0) AS count FROM " .. tableName )[ 1 ].count

if ( tonumber( countLines ) > 0 ) then


------------------------------------------------------------------------------------------------------------------------------------

If you have modified atlaschat files in any way then you have to migrate over your changes. Do not complain to me.