require 'selenium-webdriver'
require 'pry'

class Post
  def initialize( driver, element)
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
    find_iframe_depth(post)
    begin
      vid = @driver.find_element(css: '.video.media')
      vid.send_keys( :space )
		  time = @driver.find_element( css: '.progress-control')
      @time = time.attribute('data-tooltip').to_i
    rescue Selenium::WebDriver::Error::NoSuchElementError 
      @time = wait_time 
    end
  end

  def sleep_time( post )
    if @type == :gif
      sleep( gif_length( post ) * 1.2)
    else
      @time = wait_time
      sleep(@time)
    end
    print [@type, @time, @ref, "\n"].join(' ')
  end

  def wait_time
    if ARGV[1]
      ARGV[1].to_i
    else
      6
    end
  end

  def find_iframe_depth(level)
    begin
      # search for an iframe
      nlevel = level.find_element(css: 'iframe')
      # if found set driver to iframe context
      @driver.switch_to.frame( nlevel )
      # call this method with next level
      find_iframe_depth(@driver.find_element(css: 'body'))
    rescue Selenium::WebDriver::Error::NoSuchElementError 
      @driver
    end
  end
end
