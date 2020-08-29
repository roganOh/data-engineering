CREATE SCHEMA raw_data;
CREATE SCHEMA analytics;
CREATE SCHEMA adhoc;

-----
CREATE GROUP analytics_users;
GRANT USAGE ON SCHEMA analytics TO GROUP analytics_users;
GRANT USAGE ON SCHEMA raw_data TO GROUP analytics_users;
GRANT SELECT ON ALL TABLES IN SCHEMA analytics TO GROUP analytics_users;
GRANT SELECT ON ALL TABLES IN SCHEMA raw_data TO GROUP analytics_users;
GRANT ALL ON SCHEMA adhoc to GROUP analytics_users;
GRANT ALL ON ALL TABLES IN SCHEMA adhoc TO GROUP analytics_users;

-----
CREATE USER keeyong PASSWORD '...';
ALTER GROUP analytics_users ADD USER keeyong;

-----
SELECT 'DROP TABLE IF EXISTS ' || schemaname || '.' || tablename || ' CASCADE;' FROM pg_tables WHERE tableowner not in ('rdsdb', 'admin')
SELECT 'DROP USER ' || usename || ';' FROM pg_user WHERE usename not in ('rdsdb', 'admin');
SELECT 'DROP SCHEMA ' || s.nspname || ' CASCADE;'
FROM pg_catalog.pg_namespace s
JOIN pg_catalog.pg_user u ON u.usesysid = s.nspowner
WHERE u.usename NOT IN ('admin', 'rdsdb');
