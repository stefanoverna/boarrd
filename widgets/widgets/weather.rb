module Widgets
  class Weather < BaseWidget

    class WeatherItem
      include ROXML

      xml_accessor :location
      xml_accessor :link
    end

    class Input < Widgets::Input

      xml_accessor :item, :as => WeatherItem

      def refresh
        self.items = []
      end

    end
    
    class YahooWeather < Input
      include Widgets::Configurable

      setting :location do
        label "Location"
        hint "Input a place as specific as possible (e.g. Turin, Italy)"
        input :as => :string
        is_required
      end

      def refresh
        unless self.valid?
          raise ValidationError, self.errors
        end
        
        self.item = WeatherItem.new
        self.item.location = CGI::escape(self.location)

      end

      self.title = "Weather"
      self.slug = :"weather"

    end

    self.inputs = [ Widgets::Weather::YahooWeather ]
    self.slug = :"weather"
    self.title = "Weather"

  end
end
