Mime::Type.register_alias "text/html", :iphone 
ActionView::Base.send :include, Iphone4r::Helper::Ibug
ActionController::Base.send :include, Iphone4r::Controller::IphoneFormatFilter
