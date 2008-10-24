
  Comatose.configure do |config|
    # Sets the text in the Admin UI's title area
    config.admin_title = "DragonBoat.com - Admin"
    config.admin_sub_title = "&nbsp;"
    #config.disable_caching = true
    config.helpers << :application_helper
 
    config.includes << :authenticated_system
    config.admin_includes << :tinymce_use
    config.admin_includes << :authenticated_system

    # authorization
    config.admin_authorization = :admin_login_required
    config.disable_caching = true

    config.admin_get_author do
      current_user.login
    end
  end
