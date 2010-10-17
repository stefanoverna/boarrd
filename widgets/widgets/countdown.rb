module Widgets
  class Countdown < BaseWidget

    class CountdownItem
      include ROXML

      xml_accessor :datetime
    end

    class Input < Widgets::Input

      xml_accessor :item, :as => CountdownItem

      def refresh
        self.items = []
      end

    end
    
    class CountdownDate < Input
      include Widgets::Configurable

      setting :datetime do
        label "date and time"
        input :as => :datetime
        is_required
      end

      def refresh
        unless self.valid?
          raise ValidationError, self.errors
        end
        
        self.item = CountdownItem.new
        self.item.date = self.date
      end

      self.title = "Countdown"
      self.slug = :"countdown"

    end

    self.inputs = [ Widgets::Countdown::CountdownDate ]
    self.slug = :"countdown"
    self.title = "Countdown"

  end
end
