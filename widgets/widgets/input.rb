module Widgets
  class Input
    include ROXML
    include ActiveModel::Validations

    class << self
      attr_accessor :title, :slug
    end

    def initialize(params = {})
      update params
    end

    def update(params)
      key = params.keys.match{ |p|
        p.match(/\(5i\)$/)
      }
      if param = key.gsub /\(5i\)$/, ''
        DateTime.civil(
          params[param+"(1i)"],
          params[param+"(2i)"],
          params[param+"(3i)"],
          params[param+"(4i)"],
          params[param+"(5i)"]
        )
      end
      params.each_pair do |k, v|
        send("#{k}=", v) rescue true
      end
    end

    def refresh
    end

  end
end