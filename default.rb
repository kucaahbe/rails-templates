# TODO:
# html5boilerplate
# haml
# rspec
# cucumber
# gitignores

remove_file 'vendor/plugins'

# uncomment therubyracer:
gsub_file 'Gemfile', "# gem 'therubyracer'", "gem 'therubyracer'"

# remove unused comments in a Gemfile
['Bundle edge', 'gem', 'To use', 'Deploy', 'Use'].each do |regexp|
  gsub_file 'Gemfile', /^#\s#{regexp}.*\n?$/, ''
end

gem_group :development do
  gem "letter_opener"
  gem "thin"
end
