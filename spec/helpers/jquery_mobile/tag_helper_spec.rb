require 'spec_helper'
require 'helpers/jquery_mobile/tag_helper'

#include ActionView::Helpers::UrlHelper

module JqueryMobile
  describe TagHelper do
    it { TagHelper.should be_a(Module) }

    let(:tag) { mock "Tag" } # for expecting content_tag
    let(:random_tag) { mock "Random Tag" } # for stubbing content_tag
    let(:helper) do
      Class.new.tap do |cls|
        cls.send :include, JqueryMobile::TagHelper
      end.new.tap do |helper|
        helper.stub(:render).and_return('[something rendered]')
        helper.stub(:content_tag).and_return(random_tag)
        helper.stub(:content_for).and_return(true)
      end
    end

    def html(text)
      Capybara::string(text)
    end

    context "options" do
      shared_examples 'initialized options' do
        it { should_not be_nil }
        it { should be_empty }
        it { should be_a(Hash) }
      end

      context 'for page' do
        subject { helper.page_options }
        it_behaves_like 'initialized options'
      end
      context 'for header' do
        subject { helper.header_options }
        it_behaves_like 'initialized options'
      end
      context 'for content' do
        subject { helper.content_options }
        it_behaves_like 'initialized options'
      end
      context 'for footer' do
        subject { helper.footer_options }
        it_behaves_like 'initialized options'
      end
    end

    context "injector" do
      let(:block) { lambda { "hrrhrr" } }
      context "for header" do
        it "should set options" do
          helper.for_header({:class => 'foo'}, &block)
          helper.header_options[:class].should == 'foo'
        end
        it "should use Rails' content_for" do
          helper.should_receive(:content_for).with(:header, &block)
          helper.for_header(&block)
        end
      end
      context "for footer" do
        it "should set options" do
          helper.for_footer({:class => 'foo'}, &block)
          helper.footer_options[:class].should == 'foo'
        end
        it "should use Rails' content_for" do
          helper.should_receive(:content_for).with(:footer, &block)
          helper.for_footer(&block)
        end
      end
    end

    context "mobile_page" do
      it "should render partial 'mobile_page' so it can be overridden by other engines" do
        helper.should_receive(:render).with('mobile_page').and_return('the page')
        helper.mobile_page.should == 'the page'
      end
    end

    context "mobile_tag" do
      it "should render a page" do
        helper.should_receive(:content_tag).with('div', 'data-role' => 'page').and_return(tag)
        helper.mobile_tag(:role => 'page').should == tag
      end
      it "should apply role, theme and fixed" do
        helper.should_receive(:content_tag).with('div', 'data-role' => 'header', 'data-theme' => 'b', 'data-position' => 'fixed').and_return(tag)
        helper.mobile_tag(:role => 'header', :theme => 'b', :fixed => true).should == tag
      end
      it "should accept another tag name" do
        helper.should_receive(:content_tag).with('lol', 'data-role' => 'cat').and_return(tag)
        helper.mobile_tag(:role => 'cat', :tag => 'lol').should == tag
      end
    end

    context "mobile_options" do
      let(:other) { {:foo => 23 } }
      it "should create a new object" do
        new_opts = helper.mobile_options(other)
        new_opts.object_id.should_not == other.object_id
      end

      it "should not modify other options" do
        new_opts = helper.mobile_options(other)
        new_opts.should == other
      end

      it "should set role" do
        opts = helper.mobile_options(:role => 'page')
        opts['data-role'].should == 'page'
      end

      it "should set theme" do
        opts = helper.mobile_options(:theme => 'b')
        opts['data-theme'].should == 'b'
      end

      it "should apply fixed flag" do
        opts = helper.mobile_options(:fixed => true)
        opts['data-position'].should == 'fixed'
      end
    end

    context "collapsible" do
      it "should should have role 'collapsed'" do
        helper.should_receive(:mobile_tag).with(:role => 'collapsible').and_return(tag)
        helper.collapsible.should == tag
      end

      it "should have option to uncollapse it on page load" do
        helper.should_receive(:mobile_tag).with(:role => 'collapsible', 'data-collapsed' => false).and_return(tag)
        helper.collapsible(:collapsed => false).should == tag
      end
    end

    context "linked_list_of" do
      let(:collection) { %w(a bbb cc) }

      it "should create a list of numbers" do # the block here should be actually a view block, but hopefully this does not matter
        helper.should_receive(:content_tag).with(:ul, '132', :class => 'foo', 'data-role' => 'listview').and_return(tag)
        list = helper.linked_list_of(collection, :class => 'foo') { |e| e.length }
        list.should == tag
      end
    end

    context "extra_page" do
      it "should be stored in content_for :extra_pages" do
        helper.should_receive(:content_for).with(:extra_pages)
        helper.extra_page # block
      end
    end
  end

end
