module ActionView
  module Helpers
    module DateHelper
      def select_hour_with_twelve_hour_time(datetime, options = {})        
        return select_hour_without_twelve_hour_time(datetime, options) unless options[:twelve_hour].eql? true
      
        val = datetime ? (datetime.kind_of?(Fixnum) ? datetime : datetime.hour) : ''
        if options[:use_hidden]
          hidden_html(options[:field_name] || 'hour', val, options)
        else
          hour_options = []
          0.upto(23) do |hour|
            ampm = hour <= 11 ? ' AM' : ' PM'
            ampm_hour = hour == 12 ? 12 : (hour / 12 == 1 ? hour % 12 : hour)

            hour_options << ((val == hour) ?
              %(<option value="#{hour}" selected="selected">#{ampm_hour}#{ampm}</option>\n) :
              %(<option value="#{hour}">#{ampm_hour}#{ampm}</option>\n)
            )
          end
          select_html(options[:field_name] || 'hour', hour_options, options)
        end
      end
      alias_method_chain :select_hour, :twelve_hour_time
    end
  end
end