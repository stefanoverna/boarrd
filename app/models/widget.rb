require 'widgets'

class Widget < ActiveRecord::Base
  belongs_to :dashboard
  serialize :settings, Hash

  validates_presence_of :widget_type
  validates_presence_of :input_type
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

  def all_valid?(context = nil)
    valid? and input_class.new(settings).valid?
  end

  def settings
    super || {}
  end

  def all_errors
    if input_class.nil?
      super
    else
      input = input_class.new(settings)
      input.valid?
      super.merge(input.errors)
    end
  end

  def widget_data
    return nil if input_class.nil?
    request = CacheRequest.find_by_key(cache_key)
    if request.nil? or request.updated_at < 5.minutes.ago
      input = input_class.new(settings)
      input.refresh
      request = CacheRequest.find_or_initialize_by_key(cache_key)
      request.value = input.to_xml.serialize
      request.save
      input
    else
      input_class.from_xml(request.value)
    end
  end

  def cache_key
    hash = []
    self.settings.merge({:widget_type => widget_type, :input_type => input_type}).each_pair do |k,v|
      hash << "%s=%s" % [k.to_s, v.to_s]
    end
    Digest::MD5.hexdigest hash.join("&")
  end
end
