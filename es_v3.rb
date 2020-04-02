require 'selenium-webdriver'
require './es_post'
require 'pry'

class EndlessScroll

  def initialize(subreddit)
    @driver = Selenium::WebDriver.for :chrome
    @subreddit = subreddit
    @driver.manage.window.maximize
    @driver.get "http://reddit.com/r/#{@subreddit}"
    adult_check
    @list  = @driver.find_elements(:css, ".Post")
    endless_scroll(@list)
  end


  def endless_scroll(list)
    begin
      list_view(list)
    ensure
      list[-1] != nil
    end
      binding.pry
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
      Post.new( @driver, item)
      puts "#{item.ref}  : #{item.location.y}"
      # TODO if it is a media element click play
      # TODO make wait time based on content
      #sleep(5)
    end
  end

  def update_list(list)
    update = @driver.find_elements(:css, ".Post")
    cut_point = update.find_index {|el| el.ref == list[-1].ref }
    cut_point = cut_point + 1
    out = update.slice( cut_point..-1 )
    out
  end
end

EndlessScroll.new(ARGV[0])
