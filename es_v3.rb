require 'selenium-webdriver'
require 'pry'

class EndlessScroll

  def initialize(subreddit)
    @driver = Selenium::WebDriver.for :chrome
    @subreddit = subreddit
    @driver.manage.window.maximize
    @driver.get "http://reddit.com/r/#{@subreddit}"
    adult_check
    @list  = @driver.find_elements(:css, ".scrollerItem")
    endless_scroll(@list)
  end


  def endless_scroll(list)
      list_view(list)
      sleep(5)
      newer = update_list(list)
      endless_scroll(newer)
  end

  private 

  def adult_check
    begin
      @driver.find_element(:xpath, '//a[text() = "Yes"]').click
      
      rescue Selenium::WebDriver::Error::NoSuchElementError
	puts "All ages"
    end
  end

  def list_view(list)
    list.each do |item|
      @driver.execute_script("arguments[0].scrollIntoView(true)", item)
      puts "#{item}  : #{item.location.y}"
      sleep(5)
    end
  end

  def update_list(list)
    update = @driver.find_elements(:css, ".scrollerItem")
    update = only_visible(update)
    out = update[(update.length - list.length) .. update.length]
    out
  end

  def only_visible(list)
    list.delete_if {|el| !el.displayed? }
  end
end

EndlessScroll.new(ARGV[0])
