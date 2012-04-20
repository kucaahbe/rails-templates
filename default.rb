# TODO:
# html5boilerplate
# haml
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
# add usable gems
gem_group :development do
  gem "letter_opener"
  gem "thin"
end

# turn off assets logging
environment(nil, :env => "development") do
  "config.assets.logger = false"
end
