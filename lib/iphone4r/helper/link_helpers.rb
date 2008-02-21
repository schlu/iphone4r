#All of these link to helpers depend on a custom (included) version of iui being installed

module Iphone4r
  module Helper
    module LinkHelpers
      def _iphone4r_external_link_helper(text, url)
        <<-END
          <a href="#{url}" target="_external">#{text}</a>
        END
      end
      def link_to_map(text, q_value)
        _iphone4r_external_link_helper(text, "http://maps.google.com/maps?q=#{q_value}")
      end
      
      def link_to_you_tube(text, video_id)
        _iphone4r_external_link_helper(text, "http://www.youtube.com/watch?v=#{video_id}")
      end
      
      def link_to_phone(number, options = {})
        text = options[:text] || number
        _iphone4r_external_link_helper(text, "tel:#{number}")
      end
    end
  end
end