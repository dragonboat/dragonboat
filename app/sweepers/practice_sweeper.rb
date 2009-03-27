#Practice
class PracticeSweeper < ActionController::Caching::Sweeper
  observe Practice # This sweeper is going to keep an eye on the Practice model

  def after_save(practice)
    expire_cache_for(practice)
  end
  
  def after_destroy(practice)
    expire_cache_for(practice)
  end
          
  private
  def expire_cache_for(record)
    expire_page(:controller => '/practice_schedule', :action => 'index')
    #expire_page(:controller => 'practice_schedule', :action => 'index', :id => record.id)

  end
end
  