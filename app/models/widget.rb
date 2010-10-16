class Widget < ActiveRecord::Base
  belongs_to :dashboard
  serialize :settings, Hash

  validates_presence_of :widget_type
  validates_presence_of :area
  validates_presence_of :area_position

end
