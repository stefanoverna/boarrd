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
      key = params.keys.find{ |p|
        p.match(/\(5i\)$/)
      }
      if key and param = key.gsub(/\(5i\)$/, '')
        send(
          "#{param}=",
          DateTime.civil(
            params[param+"(1i)"].to_i,
            params[param+"(2i)"].to_i,
            params[param+"(3i)"].to_i,
            params[param+"(4i)"].to_i,
            params[param+"(5i)"].to_i
          )
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