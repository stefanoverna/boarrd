class Dashboard < ActiveRecord::Base
  belongs_to :user
  has_many :widgets, :dependent => :destroy

  validates_presence_of :user
  validates_presence_of :title
  normalize_attributes :title

  has_friendly_id :title, :use_slug => true

  set_ui_editable_associations
  set_ui_editable_attributes :title, :columns_count
  set_simple_form_options_for :columns_count, :collection => (2..3), :hint => "Two columns is suggested for screens with resolutions less or equal than 1024. If you have large screens, go with three columns."

end
