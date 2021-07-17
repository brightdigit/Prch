# what if docker isn't there
docker run --rm  --name floxbx-pg -e POSTGRES_HOST_AUTH_METHOD=trust -d -p 5432:5432 postgres -c log_statement=all
sleep 5
# what user name to use
psql -h localhost -U postgres < ./setup.sql
#pg_restore --verbose --clean --no-acl --no-owner -h localhost -U heartwitch -d heartwitch $1
#psql -h localhost -U postgres -d floxbx < ./grant.sql
#yes "Y" | swift run hwserver migrate 
#swift run hwserver "catalog-sync"
#ngrok http -bind-tls=true 8080 > /dev/null  & 
#pushd $2
#npm run dev > web.log & 
#popd
#ROOT_PATH=$2/dist swift run hwserver & 
#trap "trap - SIGTERM && kill -- -$$ && docker rm -f heartwitch-pg" SIGINT SIGTERM EXIT
#wait