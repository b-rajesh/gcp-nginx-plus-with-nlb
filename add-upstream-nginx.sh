curl -X POST -d '{\"server\": \"$1\"}' '-s'  'http://$2:$3/api/6/http/upstreams/$4/servers'
#curl -X POST -d '{"server": $1}' -s  'http://$2:$3/api/6/http/upstreams/$4/servers'
echo "curl -X POST -d '{\"server\": \"$1\"}' -s  'http://$2:$3/api/6/http/upstreams/$4/servers'"
