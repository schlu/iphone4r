module Iphone4r
  module Helper
    module LinkHelpers
      def link_to_map(text, q_value)
        "<a href=\"http://maps.google.com/maps?q=#{q_value}\">#{text}</a>"
      end
    end
  end
end