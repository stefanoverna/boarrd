module Widgets
  class Countdown < BaseWidget

    class Input < Widgets::Input

      xml_accessor :countdown_datetime, :as => DateTime

      def refresh
        self.items = []
      end

    end

    class CountdownDate < Input
      include Widgets::Configurable

      setting :countdown_datetime do
        label "Countdown"
        input :as => :datetime
        is_required
      end

      def refresh
        unless self.valid?
          raise ValidationError, self.errors
        end
      end

      self.title = "Countdown"
      self.slug = :"countdown"

    end

    self.inputs = [ Widgets::Countdown::CountdownDate ]
    self.slug = :"countdown"
    self.title = "Countdown"

  end
end
