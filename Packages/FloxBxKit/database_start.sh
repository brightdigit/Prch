docker run --name floxbx-pg -e POSTGRES_HOST_AUTH_METHOD=trust -d -p 5432:5432 postgres -c log_statement=all
until [ "`docker inspect -f {{.State.Running}} floxbx-pg`"=="true" ]; do
	sleep 1;
done;
sleep 3;
until [ "`psql -A -t -h localhost -U postgres -c \"SHOW server_version_num;\"`" -gt 120000 ]; do
	sleep 3;
done;
psql -h localhost -U postgres < ./setup.sql