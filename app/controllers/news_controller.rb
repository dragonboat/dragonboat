class NewsController < ApplicationController

  def index
    @news = News.find_actual(:all, :limit=>APP_CONFIG["news_per_page"])
  end
  
  def show
    @news = News.find_actual(params[:id])
    @news_contents = News.find_actual(:all, :limit=>APP_CONFIG["news_per_page"])
  end

end
