# Support custom methods and sub-resources for REST.
#
# Say you on the server configure your routes with:
#
#   map.resources :people, :new => { :register => :post },
#                          :element => { :promote => :put, :deactivate => :delete }
#                          :collection => { :active => :get }
#
#  Which creates routes for the following http requests:
#
#  POST    /people/new/register.xml #=> PeopleController.register
#  PUT     /people/1/promote.xml    #=> PeopleController.promote with :id => 1
#  DELETE  /people/1/deactivate.xml #=> PeopleController.deactivate with :id => 1
#  GET     /people/active.xml       #=> PeopleController.active
#
# This module provides the ability for Active Resource to call these
# custom REST methods and get the response back.
#
#   class Person < ActiveResource::Base
#     self.site = "http://37s.sunrise.i:3000"
#   end
#
#   Person.new(:name => 'Ryan).post(:register) #=> { :id => 1, :name => 'Ryan' }
#
#   Person.find(1).put(:promote, :position => 'Manager')
#   Person.find(1).delete(:deactivate)
#
#   Person.get(:active) #=> [{:id => 1, :name => 'Ryan'}, {:id => 2, :name => 'Joe'}]
module ActiveResource
  module CustomMethods 
    def self.included(within)
      within.class_eval do
        class << self
          include ActiveResource::CustomMethods::ClassMethods
          
          alias :orig_delete :delete
          
          def get(method_name, options = {})
            connection.get(custom_method_collection_url(method_name, options), headers)
          end
      
          def post(method_name, options = {}, body = nil)
            connection.post(custom_method_collection_url(method_name, options), body, headers)
          end
      
          def put(method_name, options = {}, body = nil)
            connection.put(custom_method_collection_url(method_name, options), body, headers)
          end
      
          # Need to jump through some hoops to retain the original class 'delete' method
          def delete(custom_method_name, options = {})
            if (custom_method_name.is_a?(Symbol))
              connection.delete(custom_method_collection_url(custom_method_name, options), headers)
            else
              orig_delete(custom_method_name, options)
            end
          end
        end

      end

      within.send(:include, ActiveResource::CustomMethods::InstanceMethods)
    end
    
    module ClassMethods
      def custom_method_collection_url(method_name, options = {})
        prefix_options, query_options = split_options(options)
        "#{prefix(prefix_options)}#{collection_name}/#{method_name}.xml#{query_string(query_options)}"
      end
    end
    
    module InstanceMethods
      def get(method_name, options = {})
        connection.get(custom_method_element_url(method_name, options), self.class.headers)
      end
      
      def post(method_name, options = {}, body = nil)
        if new?
          connection.post(custom_method_new_element_url(method_name, options), (body.nil? ? to_xml : body), self.class.headers)
        else
          connection.post(custom_method_element_url(method_name, options), body, self.class.headers)
        end
      end
      
      def put(method_name, options = {}, body = nil)
        connection.put(custom_method_element_url(method_name, options), body, self.class.headers)
      end
      
      def delete(method_name, options = {})
        connection.delete(custom_method_element_url(method_name, options), self.class.headers)
      end


      private
        def custom_method_element_url(method_name, options = {})
          "#{self.class.prefix(prefix_options)}#{self.class.collection_name}/#{id}/#{method_name}.xml#{self.class.send(:query_string, options)}"
        end
      
        def custom_method_new_element_url(method_name, options = {})
          "#{self.class.prefix(prefix_options)}#{self.class.collection_name}/new/#{method_name}.xml#{self.class.send(:query_string, options)}"
        end
    end
  end
end