#! /bin/bash

git pull
if [ $? -eq 0 ]
then
  bundle update
  rake db:migrate
  bundle exec rails s
fi
