#!/bin/sh

cd
name="reddit"

if [ -d "$name" ] && [ -n "$(ls -A "$name" 2>/dev/null)" ]; then
  # Do not check for now that the folder is actually a git repo
  cd "$name"
  git checkout monolith && git pull
else
  git clone -b monolith https://github.com/express42/reddit.git
  cd "$name"
fi

bundle install

puma -d
