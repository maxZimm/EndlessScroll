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
attr_reader :type, :ref, :driver

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
    @ref = post.ref
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
    begin
      vid = @driver.find_element(css: '.video.media')
      vid.send_keys( :space )
		  time = @driver.find_element( css: '.progress-control')
      @time = time.attribute('data-tooltip').to_i
    rescue Selenium::WebDriver::Error::NoSuchElementError 
      @time = 5
    end
  end

  def sleep_time( post )
    if @type == :gif
      sleep( gif_length( post ) * 1.2)
    else
      @time = 5
      sleep(@time)
    end
    print [@type, @time, @ref, "\n"].join(' ')
  end
end
