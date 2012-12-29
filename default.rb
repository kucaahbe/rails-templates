$LOAD_PATH.unshift File.dirname(__FILE__)

require 'rt/dependency'

# common clean up tasks:
remove_file 'vendor/plugins'
remove_file 'README'
remove_file 'README.rdoc'

# remove therubyracer:
gsub_file 'Gemfile', %r{^.+sstephenson.+$}, ''
gsub_file 'Gemfile', %r{^.+# gem 'therubyracer'.+$}, ''

# remove useless comments in a Gemfile
['Bundle edge', 'gem', 'To use', 'Deploy', 'Use'].each { |regexp| gsub_file 'Gemfile', /^#\s#{regexp}.*\n?$/, '' }
# remove annoying empty lines
gsub_file 'Gemfile', /\n{3,}/, "\n"

# turn off assets logging
application(nil, :env => "development") do
  "config.assets.logger = false"
end

# == Useful stuff:
RT::Feature.load_all $LOAD_PATH.first, self

# === Actual setup:

RT::Feature.invoke_all self

# config/examples:
create_file 'config/examples/.gitkeep'
append_to_file '.gitignore', <<-IGN

# ignore config files.
/config/*.yml
IGN
run "cp config/*.yml config/examples/"

rake 'db:create:all'
rake 'db:migrate'

git :init
git add: '.'
