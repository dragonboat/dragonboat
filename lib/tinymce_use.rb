module TinymceUse
  def self.included(base)
    base.uses_tiny_mce(:options => { :theme => 'advanced',
      # :mode => "textareas",
      :theme_advanced_toolbar_location => "top",
      :theme_advanced_toolbar_align => "left",
      :theme_advanced_resizing => true,
      :theme_advanced_resize_horizontal => false,
      :paste_auto_cleanup_on_paste => true,
      :theme_advanced_buttons1 => %w{ bold italic underline strikethrough separator justifyleft 
        justifycenter justifyright indent outdent separator bullist numlist forecolor backcolor separator link 
        unlink image undo redo code print},
     :theme_advanced_buttons2 => %w{ formatselect fontselect fontsizeselect pastetext pasteword selectall 
                  },
       :theme_advanced_buttons3_add => %w{ tablecontrols fullscreen flash media },
        #          :editor_selector => 'mceEditor',
   
      # :editor_selector => 'mceEditor',
      :plugins => %w{ contextmenu paste table fullscreen  advimage media print advlink}
    })
  end
end


#:theme => 'advanced',
#                  :mode => "textareas",
#                  :convert_urls => false,
 ##                 :content_css => "/stylesheets/base.css",
 #                 :remove_script_host => true,
  #                :theme_advanced_toolbar_location => "top",
  #                :theme_advanced_toolbar_align => "left",
   #               :theme_advanced_resizing => true,
   #               :theme_advanced_resize_horizontal => false,
   