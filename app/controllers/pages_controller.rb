class PagesController < FrontController
  
  def home
    @newsletter = Newsletter.new
  end
  
end
