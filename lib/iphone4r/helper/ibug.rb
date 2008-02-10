module Iphone4r
  module Helper
    module Ibug
      def include_ibug
        if RAILS_ENV == "development"
          ret = javascript_include_tag "/ibug/ibug.js"
        end
      end
    end
  end
end