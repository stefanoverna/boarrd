class Widget < ActiveRecord::Base
  belongs_to :dashboard
  serialize :settings, Hash

  set_ui_editable_associations
end
