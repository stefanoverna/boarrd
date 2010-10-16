class Dashboard < ActiveRecord::Base
  belongs_to :user
  has_many :widgets

  validates_presence_of :user
  validates_presence_of :title
  normalize_attributes :title

  has_friendly_id :title, :use_slug => true

  set_ui_editable_associations
end
