require 'selenium-webdriver'
require './es_post'
require 'pry'

class EndlessScroll

  def initialize(subreddit)
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_extension( '/home/maxzim/Documents/extension_5_18_10_0.crx')
    @driver = Selenium::WebDriver.for :chrome, options: options
    @subreddit = subreddit
    @driver.manage.window.maximize
    @driver.get "http://reddit.com/r/#{@subreddit}"
    adult_check
    @list = collect_elements
    endless_scroll(@list)
  end


  def endless_scroll( list )
    # TODO break apart the process of moving throuh the list view
    # TODO enable gif types to be processed completely 
    # TODO list_view will continue from where it left off after previous gif
      list_view(list)
      stale_check( list )
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
      post =  Post.new( @driver, item)
      @last_post_ref = post.ref
      if post.type == :gif
        break
      end
    end
  end

  def update_list(list)
    stale_check( list )
    update = collect_elements
    if @last_post_ref
      cut_point = update.find_index {|el| el.ref == @last_post_ref }
      cut_point = cut_point + 1
      out = update.slice( cut_point..-1 )
      return out
    else
      return update
    end
  end

  def stale_check( item )
    puts 'Reload' 
    if !item.empty?
      begin
        item[0].find_elements( css: '.Post')
      rescue Selenium::WebDriver::Error::StaleElementReferenceError 
        @driver.switch_to.default_content
      end
    else
     @list = collect_elements
    end
  end

  def collect_elements
    @driver.find_elements( css: '.Post')
  end
end

EndlessScroll.new(ARGV[0])
