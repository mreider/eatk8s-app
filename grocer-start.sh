trap "exit" INT TERM ERR
trap "kill 0" EXIT

rackup &
bundle exec sidekiq -r ./grocer.rb -q default

wait