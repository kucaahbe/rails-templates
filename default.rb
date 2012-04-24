# TODO:
# haml as default template engine for generators
# rspec
# cucumber

remove_file 'vendor/plugins'
create_file 'config/examples/.gitkeep'
append_to_file '.gitignore' do
  <<-IGN

# ignore config files.
/config/*.yml
  IGN
end

# uncomment therubyracer:
gsub_file 'Gemfile', "# gem 'therubyracer'", "gem 'therubyracer'"
# remove unused comments in a Gemfile
['Bundle edge', 'gem', 'To use', 'Deploy', 'Use'].each do |regexp|
  gsub_file 'Gemfile', /^#\s#{regexp}.*\n?$/, ''
end
gsub_file 'Gemfile', /\n{3,}/, "\n"
# add usable gems
gem_group :development do
  gem "letter_opener"
  gem "thin"
end

# turn off assets logging
environment(nil, :env => "development") do
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

  environment(nil, :env => "production") do
    'config.assets.precompile += %w( polyfills.js )'
  end
end

# copying sample yaml stuff
run "cp config/*.yml config/examples/"

git :init
git add: '.'
