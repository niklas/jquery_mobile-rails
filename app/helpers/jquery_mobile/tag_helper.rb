module JqueryMobile::TagHelper


  # put this into your layout. It will yield your action-renderings for you
  def mobile_page(options = {})
    page_options.merge! options
    render 'mobile_page'
  end

  def self.injector(name)
    module_eval <<-EOEVAL, __FILE__, __LINE__
      def for_#{name}(options={}, &block)
        #{name}_options.merge! options
        content_for :#{name}, &block
      end
    EOEVAL
  end

  injector :header
  injector :footer

  def self.options(name)
    module_eval <<-EOEVAL, __FILE__, __LINE__
      def #{name}_options
        @#{name}_options ||= {}
      end
    EOEVAL
  end

  options :page
  options :header
  options :content
  options :footer

  # Renders a JqueryMobile specific tag
  # addition options
  #   :role   - JQM role (page, header, footer, etc)
  #   :theme  - single letter color swatches (a,b or even d),
  #             see http://jquerymobile.com/demos/1.0/docs/api/themes.html
  #   :fixed  - do not apply page transition to this element, see
  #             http://jquerymobile.com/demos/1.0/docs/pages/touchoverflow.html
  #   :tag    - you don't want a div?
  def mobile_tag(options = {}, &block)
    options = mobile_options(options)
    tag_name = options.delete(:tag) || 'div'
    content_tag tag_name, options, &block
  end

  def page_tag(options = {}, &block)
    mobile_tag(options.merge(:role => 'page'), &block)
  end

  def extra_page(options ={}, &block)
    content_for :extra_pages do
      page_tag options, &block
    end
  end

  def back_button_to(label, url, options = {})
    link_to label, url, options.merge('data-rel' => 'back')
  end

  def linked_list_of(collection, options = {}, &block)
    content_tag :ul, mobile_options(options, :role => 'listview') do
      collection.map { |e| block.call(e) }.join.html_safe
    end
  end

  def mobile_options(options, extra={})
    options.merge(extra).tap do |o|
      o.reverse_merge!('data-role'     => o.delete(:role))  if o.has_key?(:role)
      o.reverse_merge!('data-position' => 'fixed')          if o.delete(:fixed)
      o.reverse_merge!('data-theme'    => o.delete(:theme)) if o.has_key?(:theme)
    end
  end

  def collapsible(options={}, &block)
    options.merge!('data-collapsed' => options.delete(:collapsed)) if options.has_key?(:collapsed)
    mobile_tag options.merge(:role => 'collapsible'), &block
  end
end

