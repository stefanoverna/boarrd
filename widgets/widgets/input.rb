module Widgets
  class Input
    include ROXML
    include Validatable

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