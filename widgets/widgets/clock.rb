module Widgets
  class Clock < BaseWidget

    class Input < Widgets::Input
      include Widgets::Configurable

      def refresh
      end

      self.slug = :"clock"
      self.title = "Clock"
    end

    self.inputs = [ Widgets::Clock::Input ]
    self.slug = :"clock"
    self.title = "Clock Widget"

  end
end
