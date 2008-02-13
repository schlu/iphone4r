module Iphone4r
  module Controller
    module IphoneFormatFilter
      def adjust_format_for_iphone
        request.format = :iphone if iphone_request?
      end

      def iphone_request?
        (request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"][/(Mobile\/.+Safari)/])
      end
    end
  end
end