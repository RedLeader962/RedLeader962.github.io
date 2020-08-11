#!/usr/bin/env bash

# Utility script use by Pycharm run configuration

ps aux |grep jekyll |awk '{print $2}' | xargs kill -9

# make sure 'github-pages' gem is the latest version since it has a cascading effect on the 'jekyll' version and so on
bundle update --all