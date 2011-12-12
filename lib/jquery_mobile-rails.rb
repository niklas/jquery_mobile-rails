module JqueryMobile
  module Rails
    class Engine < ::Rails::Engine
      initializer 'jquery_mobile.include_helper' do
        ApplicationController.class_eval do
          include JqueryMobile::TagHelper
        end
      end
    end
  end
end
