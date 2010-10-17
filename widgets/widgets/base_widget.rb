module Widgets
  class BaseWidget
    class << self
      attr_accessor :title, :slug, :inputs

      def available_inputs
        self.inputs
      end

      def find_input_by_slug(slug)
        return nil if slug.nil? or slug.blank?
        self.inputs.find do |input|
          input.slug == slug.to_sym
        end
      end
    end
  end
end