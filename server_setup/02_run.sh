#!/bin/bash

bolt plan run server_setup::deploy -i ./inventory.yaml -t prometeo -vvv

