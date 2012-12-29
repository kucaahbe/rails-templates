module RT
  module Dependency
    @@gems={}
    @@envs={}
    @@initializers={}
    @@generators=[]

    class <<self

      def add opts={}
        @@gems.merge!(opts[:gems]||{}) { |key, v1, v2| ([v1].concat [v2]).flatten }

        @@envs.merge!(opts[:envs]||{}) { |key, v1, v2| v1+"\n"+v2 }

        @@generators << opts[:generator] if opts[:generator]

        @@initializers.merge! opts[:initializer]||{}
      end

      def gems
        @@gems
      end

      def envs
        @@envs
      end

      def generators
        @@generators
      end

      def initializers
        @@initializers
      end

    end

  end
end
