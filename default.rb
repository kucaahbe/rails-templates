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

RT::Feature.add(
  gems: { development: 'thin'}
)
RT::Feature.add(
  gems: { development: 'letter_opener'},
  envs: { development: "config.action_mailer.delivery_method = :letter_opener" }
)
RT::Feature.add(
  gems: { test: 'fabrication'},
  initializer: {
    fabrication: <<-I
if defined? Fabrication

Fabrication.configure do |config|
  config.fabricator_path = 'fabricators'
  config.path_prefix = Rails.root
  config.sequence_start = 10000
end

end
I
  }
)
if yes? 'setup html5-rails?'
  RT::Feature.add(
    gems: {
      default: ['html5-rails'],
      assets: ['compass-rails','compass-h5bp']
    },
    generator: 'html5:install',
    envs: { all: 'config.assets.precompile += %w( polyfills.js )' }
  )
end

# === Actual setup:

RT::Feature.load_all self

# config/examples:
create_file 'config/examples/.gitkeep'
append_to_file '.gitignore', <<-IGN

# ignore config files.
/config/*.yml
IGN
run "cp config/*.yml config/examples/"

git :init
git add: '.'
