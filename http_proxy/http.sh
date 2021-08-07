# usage:  . http.sh [ip:port]

http_proxy=http://127.0.0.1:58010

if [[ $# > 0 ]]; then
  http_proxy=http://$1
fi
echo "export https_proxy=${http_proxy}"

export http_proxy=$http_proxy
export https_proxy=$http_proxy
curl google.com

