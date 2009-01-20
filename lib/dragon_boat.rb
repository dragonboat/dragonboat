module DragonBoat
  def self.included(base)
    base.before_filter  :leave_secure_site, :www_check
    base.send :helper_method
  end
  
private
#request.host
  def www_check
    (redirect_to "http://www.#{APP_CONFIG['hostname']}#{request.request_uri}" and return false) unless request.subdomains.include?('www')
  end
  
  def leave_secure_site
    if APP_CONFIG['SSL']
    (redirect_to "http://#{APP_CONFIG['hostname']}#{request.request_uri}" and return false) if request.ssl?
    end
  end

  def secure_site
    if APP_CONFIG['SSL']
      unless request.ssl?
        redirect_to "https://#{APP_CONFIG['hostname']}#{request.request_uri}"
        return false
      end #unless RAILS_ENV == 'development'
    end
  end
end