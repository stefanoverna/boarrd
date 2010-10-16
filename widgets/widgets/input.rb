module Widgets
  class Input
    include ROXML
    include Validatable

    class << self
      attr_accessor :title, :slug
    end

    def initialize(params = {})
      update params
    end

    def update(params)
      params.each_pair do |k, v|
        send "#{k}=", v
      end
    end

    def refresh
    end

  end
end