#!/bin/bash

NAME=$(mktemp -p /tmp XXXXXX)

function cleanup() {
    docker kill $(basename $NAME)
    rm $NAME
}

trap cleanup EXIT

if [ $# -eq 2 ]; then
    curl http://60s/get?id="$2" > $NAME || exit 1
    DOCKERFLAGS=(-v $NAME:/script)
    SARGS=(/script)
fi

bash filter.sh "$1" || exit 1

docker run $DOCKERFLAGS --name $(basename $NAME) -it --rm -m 64m openrepl/$1 $SARGS