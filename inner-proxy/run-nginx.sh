#!/bin/bash -x

# Update the Nginx site config with the api server
#sed -i s/\{\{REST_SERVICE\}\}/$REST_SERVICE/ /etc/nginx/conf.d/default.conf
#sed -i s/\{\{SECURE_SERVICE\}\}/$SECURE_SERVICE/ /etc/nginx/conf.d/default.conf

# Inject the HTTPS enforcement logic into the Nginx configuration script
FORCE_HTTPS=`echo ${FORCE_HTTPS:-false} | tr '[:upper:]' '[:lower:]'`
if [[ ${FORCE_HTTPS} == "true" ]]; then
  HTTPS_ENFORCEMENT=true
else
  HTTPS_ENFORCEMENT=false
fi
sed -i s/\{\{FORCE_HTTPS\}\}/$HTTPS_ENFORCEMENT/ /etc/nginx/conf.d/default.conf

cat /etc/nginx/conf.d/default.conf

# Retry a command until it succeeds or until the
# maximum number of attempts is reached.
retry() {
  local -r -i max_attempts="$1"; shift
  local -r cmd="$@"
  local -i attempt_num=1

  until $cmd
  do
    if (( $attempt_num == $max_attempts ))
    then
      echo "All $attempt_num connection attempts failed!"
      return 1
    else
      echo "Attempt $attempt_num of $max_attempts failed! Trying again in 1 second..."
      attempt_num=$((attempt_num+1))
      sleep 1
    fi
  done
}

# Confirm that the API server is online
retry 120 timeout 5 /opt/port.pl rest:8080 #$REST_SERVICE
retry 120 timeout 5 /opt/port.pl secure:8080 #$SECURE_SERVICE

# Once the server has started, run NGINX
if [[ $? -eq 0 ]]; then
  echo "Server ${TEST_SOCKET} is online. Starting Nginx..."
  nginx-debug -g 'daemon off;'
else
  echo "Timeout connecting to server ${TEST_SOCKET}"
  exit 1
fi

