require 'widgets'

class Widget < ActiveRecord::Base
  belongs_to :dashboard
  serialize :settings, Hash

  validates_presence_of :widget_type
  validates_presence_of :area
  validates_presence_of :area_position
  validates_presence_of :guid

  has_friendly_id :guid

  def widget_class
    Widgets::find_by_slug(widget_type)
  end

  def input_class
    widget_class.find_input_by_slug(input_type)
  end

end
