#!/bin/bash -ex

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

STACK_NAME=proxy-test

cd inner-proxy
docker build . --tag=inner-proxy
cd ..

cd outer-proxy
docker build . --tag=outer-proxy
cd ..

docker stack deploy -c docker-compose.yml --prune $STACK_NAME

cd rest-server
PROXY_PORT=`npm run -s get-port --serviceName=${STACK_NAME}_outer --targetPort=8080`
cd ..

retry 120 timeout 5 ./port.pl localhost:${PROXY_PORT}

cd rest-server
npm run -s get -- $OUTER_PROXY

docker stack rm $STACK_NAME


