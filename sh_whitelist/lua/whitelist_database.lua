/**
* Database configuration
**/

-- Which database mode to use.
-- Available modes: mysqloo, sqlite
SH_WHITELIST.DatabaseMode = "sqlite"

-- If mysqloo is enabled above, the login info for the MySQL server.
-- The tables will be created automatically.
SH_WHITELIST.DatabaseConfig = {
	host = "localhost",
	user = "root",
	password = "",
	database = "mysql",
	port = 3306,
}