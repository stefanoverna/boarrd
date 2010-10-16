require File.join(File.expand_path(File.dirname(__FILE__)), "configurable", "setting")

module Widgets

  module Configurable
    extend ActiveSupport::Concern

    module ClassMethods

      def setting(name, &block)
        setting = Setting.new(name)
        setting.instance_eval(&block)
        settings << setting

        attr_accessor name
        setting.validations.each do |validation|
          self.send validation[:name], *validation[:args]
        end
      end

      def settings
        @settings ||= []
      end
    end

    module InstanceMethods

      def settings
        self.class.settings
      end

    end

  end

end