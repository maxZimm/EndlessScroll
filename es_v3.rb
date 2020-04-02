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


  def endless_scroll( list )
    # We have 2 cases for what needs to be consumed by update list
    # 1 it's an image and the driver hasn't changed so we proceed as normal, list_view iterates to next step of each loop
    # 2 it'a a gif and we break out of each loop which then sends back into endless_scroll method
    # however the local variable list is still assigned to the origial @list with stale elements
    # this is not good. 
    # TODO identify/confirm that this @list is the problem
    # TODO break apart the process of moving throuh the list view
    # TODO enable gif types to be processed completely 
    # TODO list_view will continue from where it left off after previous gif
      list_view(list)
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
      if post.type == :gif
        #@driver.switch_to.default_content maybe do this within update
        break
      end
    end
  end

  def update_list(list)
    stale_check( list )
    update = @driver.find_elements(:css, ".Post")
    if !list.empty?
      cut_point = update.find_index {|el| el.ref == list[-1].ref }
      cut_point = cut_point + 1
      out = update.slice( cut_point..-1 )
      return out
    else
      return update
    end
  end

  def stale_check( item )
    puts item.class
    binding.pry
  end
end

EndlessScroll.new(ARGV[0])
