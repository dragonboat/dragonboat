module ActionController
  module Macros
    module InPlaceEditing #:nodoc:
      def self.append_features(base) #:nodoc:
        super
        base.extend(ClassMethods)
      end

      # Example:
      #
      #   # Controller
      #   class BlogController < ApplicationController
      #     in_place_collection_edit_for :story, :title
      #   end
      #
      #   # View
      #   <%= in_place_collection_editor_field :story, 'title', :collection => COLLECTION %>
      module ClassMethods
        # Collection should be in the format [[text, value], [text2, value2]] or [value, value2]
        def in_place_collection_edit_for(object, attribute, collection, update=nil)
          define_method("set_#{object}_#{attribute}") do
            @item = object.to_s.camelize.constantize.find(params[:id])
            @item.update_attribute(attribute, params[:value])
            text = collection.inject('') do |memo, element|
              if !element.is_a?(String) and element.respond_to?(:first) and element.respond_to?(:last)
                element.last.to_s == params[:value] ? element.first : memo
              else
                element.to_s == params[:value] ? element.to_s : memo
              end
            end
            if params['tag_id']
              render :update do |page|
                page.replace_html(params['tag_id'], :partial=>"td_visible", :locals=>{:block=>@item})
              end
            else
              render :text => text.blank? ? 'нажмите для редактирования...' : text
            end
          end
        end
      end
    end
  end
end
