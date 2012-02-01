# Opens a Chrome Window in the size of a standard smartphone
#
# requirements: 
#   * Chrome (d'ah!)
#   * ChromeDriver http://code.google.com/p/selenium/wiki/ChromeDriver
#
# usage:
#
# put the following in you `features/support/env.rb` (Spork.prefork)
#
#   require 'cucumber/capybara/mobile_chrome'
#   Capybara.javascript_driver = :mobile_chrome


Capybara.register_driver :mobile_chrome do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome).tap do |driver|
    width, height = 480 + 8, 800 + 57 # Samsung Nexus S on Linux.

    # Resize window. In Firefox and Chrome, must create a new window to do this.
    # http://groups.google.com/group/webdriver/browse_thread/thread/e4e987eeedfdb586
    browser = driver.browser
    handles = browser.window_handles
    browser.execute_script("window.open('about:blank','_blank','width=#{width},height=#{height}');")
    browser.close
    browser.switch_to.window((browser.window_handles - handles).pop)
    browser.execute_script("window.resizeTo(#{width}, #{height}); window.moveTo(1,1);")
  end
end
