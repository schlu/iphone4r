Mime::Type.register_alias "text/html", :iphone 
ActionView::Base.send :include, Iphone4r::Helper::Ibug
ActionView::Base.send :include, Iphone4r::Helper::LinkHelpers
ActionController::Base.send :include, Iphone4r::Controller::IphoneFormatFilter

module Iphone4r
  VERSION = "0.1"
end
