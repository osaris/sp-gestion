class PagesController < ApplicationController
  
  def home
    @newsletter = Newsletter.new
  end
  
end
