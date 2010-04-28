class PagesController < FrontController
  
  def home
    @newsletter = Newsletter.new
  end
  
  def bye
  end
  
end
