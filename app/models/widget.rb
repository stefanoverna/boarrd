class Widget < ActiveRecord::Base
  belongs_to :dashboard
  serialize :settings, Hash
end
