require 'widgets'
require 'ostruct'

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
    widget_class.try(:find_input_by_slug, input_type)
  end

  def dashed_widget_type
    widget_type.gsub /-/, "_"
  end

  def valid?(context = nil)
    if input_class.nil?
      super
    else
      super and input_class.new(settings).valid?
    end
  end

  def errors
    if input_class.nil?
      super
    else
      input = input_class.new(settings)
      input.valid?
      super.merge(input.errors)
    end
  end

  def settings_pseudo_model
    WidgetSetting.new(settings.merge({:errors_on_attribute => errors, :errors_on_association => []}))
  end
end
