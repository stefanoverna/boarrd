class Dashboard < ActiveRecord::Base
  belongs_to :user
  has_many :widgets

  validates_presence_of :user
  validates_presence_of :title
  normalize_attributes :title
end
