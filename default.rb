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

# add useful gems
gem_group :development do
  gem "letter_opener"
  gem "thin"
end

# letter opener default delivery method
application(nil, :env => "development") do
  "config.action_mailer.delivery_method = :letter_opener"
end

# turn off assets logging
application(nil, :env => "development") do
  "config.assets.logger = false"
end

if yes? 'setup html5-rails?'
  gem_group :assets do
    gem 'compass-rails'
    gem 'compass-h5bp'
  end
  gem 'haml-rails'
  gem 'jquery-rails'
  gem 'html5-rails'

  run 'bundle'

  generate 'html5:install'

  application 'config.assets.precompile += %w( polyfills.js )'
end

# config/examples:
create_file 'config/examples/.gitkeep'
append_to_file '.gitignore', <<-IGN

# ignore config files.
/config/*.yml
IGN
run "cp config/*.yml config/examples/"

git :init
git add: '.'
