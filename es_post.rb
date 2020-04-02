

class Post
  def initialize( driver, element)
    @driver = driver
    @element = element
    puts post_type( @element )
    scroll_to( @element )
  end
  # TODO if it is a media element click play
  # TODO make wait time based on content

  def post_type(post)
    begin
      post.find_element( css: 'iframe')
      @type = :gif
    rescue Selenium::WebDriver::Error::NoSuchElementError 
      @type = :image
    end 
    @type
  end

  def scroll_to(post)
      @driver.execute_script( "arguments[0].scrollIntoView( { 'behavior': 'smooth',
      'block': 'center'})", post)
      sleep( 6 )
  end

  def gif_length( post )
    l1 = post.find_element( css: 'iframe')
    @driver.switch_to.frame( l1 )
    l2 = post.find_element( css: 'iframe')
    @driver.switch_to.frame( l1 )
    l3 = post.find_element( css: 'iframe')
    l3.find_element( css: 'progress-control')
  end
end
