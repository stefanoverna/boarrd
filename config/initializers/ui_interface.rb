require "active_record"

module UIInterface

  def self.included(base)
    base.send :extend, ClassMethods
    #base.send :include, InstanceMethods
  end

  module ClassMethods

    def ui_editable_associations
      @ui_editable_associations || self.reflect_on_all_associations.map(&:name)
    end

    def ui_editable_attributes
      @ui_editable_attributes || self.new.attributes.keys.map(&:to_sym).delete_if {|a| [:id, :created_at, :updated_at].include? a or a.to_s.match /_id$/ }
    end

    def belongs_to_associations
      self.reflect_on_all_associations.delete_if {|a| a.macro != :belongs_to}.map(&:name)
    end

    def set_ui_editable_associations(*args)
      @ui_editable_associations = args
    end

    def set_ui_editable_attributes(*args)
      @ui_editable_attributes = args
    end

    def set_simple_form_options_for(*args)
      options = args.extract_options!
      @simple_form_options ||= {}
      args.each do |attr|
        @simple_form_options[attr] ||= {}
        @simple_form_options[attr].merge!(options)
      end
    end

    def simple_form_options_for(attr)
      @simple_form_options ||= {}
      @simple_form_options[attr] || {}
    end



  end

end

ActiveRecord::Base.send :include, UIInterface