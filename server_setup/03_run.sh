#!/bin/bash

bolt plan run server_setup::mgmt_puppet -i ./inventory.yaml -t localhost -vvv

