#!/bin/bash
rackup &
bundle exec sidekiq -r ./grocer.rb -q default