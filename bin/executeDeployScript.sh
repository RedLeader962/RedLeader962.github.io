#!/usr/bin/env bash

# Utility script use by Pycharm run configuration

ps aux |grep jekyll |awk '{print $2}' | xargs kill -9

# execute the deploy script
./bin/deploy --user
