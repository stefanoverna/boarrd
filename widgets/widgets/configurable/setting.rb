module Widgets
  module Configurable
    class Setting

      include ActiveSupport::Configurable

      def initialize(name)
        config.name = name
        @validations = []
        "Puts initialized"
      end

      [:input, :label, :hint, :default_value, :collection].each do |method|
        define_method method do |val|
          config[method]= val
        end
      end

      def validations
        @validations
      end

      def method_missing(method, *args, &block)

        validation_mappers = {
          :is_required => :validates_presence_of,
          :has_format => :validates_format_of,
          :is_numerical => :validates_numericality_of
        }

        if validation_mappers.include? method
          @validations << {
            :name => validation_mappers[method],
            :args => [ config.name.to_sym ] + args
          }
        end

      end

    end
  end
end