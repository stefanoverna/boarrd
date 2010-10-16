#!/bin/bash

cap deploy:update_code
cap deploy:finalize_update
cap deploy:symlink
cap deploy:update
cap deploy:update_db
cap deploy:finalize
