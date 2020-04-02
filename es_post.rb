require 'selenium-webdriver'
require 'pry'

class Post
  def initialize( driver, element)
      #@driver = Selenium::WebDriver.for :chrome
      @driver = driver
      @element = element
      @time 
      post_action( @element )
  end
  # TODO if it is a media element click play
  # TODO make wait time based on content | DONE
  # TODO fix missing context when driver is assinged to default content
attr_reader :type, :ended, :driver

  def post_action( post )
    post_type( post )
    scroll_to( post )
    sleep_time( post )
  end

  def post_type(post)
    begin
      post.find_element( css: 'iframe')
      @type = :gif
    rescue Selenium::WebDriver::Error::NoSuchElementError 
      @type = :image
    end 
    puts "#{ post.ref } | #{ post.location.y }"
    @type
  end

  def scroll_to(post)
      @driver.execute_script( "arguments[0].scrollIntoView( { 'behavior': 'smooth',
      'block': 'center'})", post)
  end

  def gif_length( post )
    l1 = post.find_element( css: 'iframe')
    @driver.switch_to.frame( l1 )
    l2 = @driver.find_element( css: 'iframe')
    @driver.switch_to.frame( l2 )
    l3 = @driver.find_element( css: 'iframe')
    @driver.switch_to.frame( l3 )
    time = @driver.find_element( css: '.progress-control')
    @time = time.attribute('data-tooltip').to_i
  end

  def sleep_time( post )
    if @type == :gif
      sleep( gif_length( post ))
    else
      @time = 4
      sleep(@time)
    end
    puts @type, @time
  end
end
