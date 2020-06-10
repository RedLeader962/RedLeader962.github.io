#!/usr/bin/env bash

ps aux |grep jekyll |awk '{print $2}' | xargs kill -9

# Compile major change to html: change to name, navigation element, ...
bundle install

# Start server for offline dev
bundle exec jekyll serve
