#!/bin/bash

if test -z "$1"
then
    echo "\$1 is empty, please select a plan from the next list: "
    bolt plan show
else
  if test -z "$2"
  then
      echo "\$2 is empty, please fill with the name of the server or with the IP Address"
  else
      bolt plan run server_setup::$1 -i ./inventory.yaml -t $2 -vvv
  fi
fi

