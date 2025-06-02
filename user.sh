#!/bin/bash
$App_name=user
source ./common.sh $App_name
is_user_root
system_user_setup
nodejs_setup
app_setup
system_setup
print_time