# jQuery Mobile for Rails

This gem vendors the jQuery Mobile 1.0 assets for Rails 3.1 and greater.
The files will be added to the asset pipeline and available for you to use.
Additionally several Rails view helpers are provided, see below.

## Installation

In your Gemfile, add this line:

    gem "jquery_mobile-rails"

You can include it by adding the following to your javascript and stylesheet files:

    //= require jquery_mobile

You're done!

## Usage

### Views

Just call `mobile_page` in your layout instead of `yield`. It will render the
complete page for you, including header and footer if they have content.

    !!!5
    %html
      %head
        %title Dr. Jan Itor
      %body
        = mobile_page


Your action views still behave as expected. Their main content will be put into
the jQuery Mobile page content. If you want to set content for header or
footer, use the correlating helpers.

    %p= @document.excerpt

    - for_header do
      %h1= @document.title

    - for_footer do
      %h3= @document.author

    - page_options.merge! 'data-add-back-btn' => true

Other helpers are available, see JqueryMobile::TagHelper

 * collapsible
 * linked_list_of collection
 * extra_page
 * .. and maybe more
