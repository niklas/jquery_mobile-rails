module JqueryMobile::TagHelper


  # put this into your layout. It will yield your action-renderings for you
  def mobile_page(options = {})
    page_options.merge! options
    render 'mobile_page'
  end

  # adds the block contents to the JqueryMobile header
  def for_header(options={}, &block)
    header_options.merge! options
    content_for :header, &block
  end

  # adds the block contents to the JqueryMobile footer
  def for_footer(options={}, &block)
    footer_options.merge! options
    content_for :footer, &block
  end

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
    options.reverse_merge!('data-role' => options.delete(:role))   if options.has_key?(:role)
    options.reverse_merge!('data-position' => 'fixed')             if options.delete(:fixed)
    options.reverse_merge!('data-theme' => options.delete(:theme)) if options.has_key?(:theme)
    tag_name = options.delete(:tag) || 'div'
    content_tag tag_name, options, &block
  end

  def page(options = {}, &block)
    mobile_tag(options.merge(:role => 'page'), &block)
  end

  def extra_page(options ={}, &block)
    content_for :extra_pages do
      page options, &block
    end
  end

  def back_button_to(label, url, options = {})
    link_to label, url, options.merge('data-rel' => 'back')
  end
end

