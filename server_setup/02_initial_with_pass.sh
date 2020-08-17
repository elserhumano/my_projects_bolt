#!/bin/bash

if test -z "$1"
then
    echo "\$1 is empty, please fill with the name of the server or with the IP Address"
else
    bolt plan run server_setup::adm_ansiblix -t $1 --password-prompt -vvv
fi

