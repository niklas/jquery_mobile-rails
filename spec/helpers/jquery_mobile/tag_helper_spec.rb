require 'spec_helper'
require 'helpers/jquery_mobile/tag_helper'

#include ActionView::Helpers::UrlHelper

module JqueryMobile
  describe TagHelper do
    it { TagHelper.should be_a(Module) }

    let(:helper) do
      Class.new.tap do |cls|
        cls.send :include, subject
      end.new
    end

    def html(text)
      Capybara::string(text)
    end

    context "mobile_page" do
      it "should render partial mobile_page so it can be overridden by other engines" do
        helper.should_receive(:render).with('mobile_page').and_return('the page')
        helper.mobile_page.should == 'the page'
      end
    end
  end

end
