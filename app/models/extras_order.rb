class ExtrasOrder < ActiveRecord::Base
  belongs_to :order
  belongs_to :extras, :polymorphic => true
end
