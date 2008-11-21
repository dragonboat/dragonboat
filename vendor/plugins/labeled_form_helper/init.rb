unless RUBY_PLATFORM =~ /java/
  require 'technoweenie/labeled_form_helper'
  ActionView::Base.send                 :include, Technoweenie::LabeledFormHelper
  ActionView::Helpers::InstanceTag.send :include, Technoweenie::LabeledInstanceTag
  ActionView::Helpers::FormBuilder.send :include, Technoweenie::FormBuilderMethods
end