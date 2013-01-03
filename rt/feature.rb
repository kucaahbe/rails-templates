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
            gems.each { |g| template.gem g }
          else
            template.gem_group gem_grp do
              begin
                gems.each { |g| template.gem g }
              rescue NoMethodError
                # in case of gems is String
                template.gem gems
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

    end

  end
end