module RT
  module Dependency
    @@gems={}
    @@envs={}
    @@generators=[]

    class <<self

      def add opts={}
        @@gems.merge!(opts[:gems]||{}) { |key, v1, v2| ([v1].concat [v2]).flatten }

        @@envs.merge!(opts[:envs]||{}) { |key, v1, v2| v1+"\n"+v2 }

        @@generators << opts[:generator] if opts[:generator]
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

    end

  end
end
