module Widgets
  class FlickrWidget < BaseWidget

    class FlickrItem
      include ROXML

      xml_accessor :image
      xml_accessor :link
      xml_accessor :title
    end

    class Input < Widgets::Input

      xml_accessor :items, :as => [FlickrItem]

      def refresh
        self.items = []
      end

    end
    
    class FlickrInput < Input
      include Widgets::Configurable

      setting :user do
        label "User"
        input :as => :string
      end

      setting :tag do
        label "Tag"
        input :as => :string
      end
      
      def refresh
        unless self.valid?
          raise ValidationError, self.errors
        end
        
        self.items = []

        begin
          flickrApi = Flickr::Api.new('e95d2033ae54c31b39f56b4624f813b5')
        
          unless self.user.blank?
            flickrApi = flickrApi.users(self.user)
          end
          
          unless self.tag.blank?
            photos = flickrApi.tag(self.tag)
          end
          
          if !photos
            photos = flickrApi.photos
          end
          
          photos[0..9].each do |photo|
            item = FlickrItem.new
            
            item.image = "http://farm" + photo['farm'] + ".static.flickr.com/" + photo['server'] + "/" + photo['id'] + "_" + photo['secret'] + "_s.jpg"
            item.link = photo.url
            item.title = photo.title

            self.items << item
          end

        rescue
          #raise ValidationError, "Invalid data!"
        end
      
      end

      self.title = "Flickr"
      self.slug = :"flickr-widget"

    end

    self.inputs = [ Widgets::FlickrWidget::FlickrInput ]
    self.slug = :"flickr-widget"
    self.title = "Flickr"

  end
end
