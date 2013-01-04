require 'yaml'

module RT
  module Feature
    @@gems={}
    @@envs={}
    @@initializers={}
    @@generators=[]

    class <<self

      def load_all from_dir, template
        Dir[File.join(from_dir,'*.yml')].each do |yml|
          data=YAML.load_file(yml)#.tap { |r| p r }
          if data.has_key?('ask') && template.yes?(data['ask'])
            add data
          elsif !data.has_key?('ask')
            add data
          end
        end
      end

      def add opts={}
        @@gems.merge!(opts['gems']||{}) { |key, v1, v2| ([v1].concat [v2]).flatten }

        @@envs.merge!(opts['envs']||{}) { |key, v1, v2| v1+"\n"+v2 }

        @@generators << opts['generator'] if opts['generator']

        @@initializers.merge! opts['initializer']||{}
      end

      def invoke_all template
        @@gems.each do |gem_grp,gems|
          if gem_grp=='default'
            gems.each { |g| Feature.install_gem template, g }
          else
            template.gem_group gem_grp do
              begin
                gems.each do |g|
                  Feature.install_gem template, g
                end
              rescue NoMethodError
                # in case of gems is String
                Feature.install_gem template, gems
              end
            end
          end
        end

        @@envs.each do |env,value|
          if env=='all'
            template.application value
          else
            template.application(nil, :env => env) { value }
          end
        end

        template.run 'bundle'

        @@generators.each do |generator|
          template.generate *generator
        end

        @@initializers.each do |initializer_name,content|
          template.initializer "#{initializer_name}.rb", content
        end
      end

      def install_gem template, gem
        case gem
        when Array
          raise "wrong parameters to install_gem: #{gem.inspect}"
        when Hash
          name = gem.delete(:name)
          args = [ name, gem ]
        when String
          args = gem
        end

        puts "gem #{args.inspect}" if debug?

        template.gem *args
      end

      protected

      def debug?
        @debug ||= ENV.has_key? 'DEBUG'
      end

    end

  end
end
