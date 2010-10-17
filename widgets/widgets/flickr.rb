require 'flickr'

module Widgets
  class Flickr < BaseWidget

    class FlickrItem
      include ROXML

      xml_accessor :img
      xml_accessor :link
    end

    class Input < Widgets::Input

      xml_accessor :items, :as => [FlickrItem]

      def refresh
        self.items = []
      end

    end
    
    class Flickr < Input
      include Widgets::Configurable

      setting :user do
        label "User"
        input :as => :string
      end

      setting :tag do
        label "Tag"
        input :as => :string
      end
      
      setting :group do
        label "Group"
        input :as => :string
      end
      
      def refresh
        unless self.valid?
          raise ValidationError, self.errors
        end
        
        flickr = Flickr::Api.new('e95d2033ae54c31b39f56b4624f813b5')
        
        if self.user
          photos = flickr.users(self.user)
        end
        
        if self.tag
          if photos
            photos = photos.tag(self.tag)
          else
            photos = flickr.tag(self.tag)
          end
        end
        
        if self.group
          if photos
            photos = photos.groups(self.group)
          else
            photos = flickr.tag(self.tag)
          end
        end
        
        throw photos
        
        #http://farm{farm-id}.static.flickr.com/{server-id}/{id}_{secret}_[mstzb].jpg

      end

      self.title = "Flickr"
      self.slug = :"flickr"

    end

    self.inputs = [ Widgets::Flickr::Flickr ]
    self.slug = :"flickr"
    self.title = "Flickr"

  end
end
