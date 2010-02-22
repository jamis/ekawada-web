class Illustration < ActiveRecord::Base
  belongs_to :parent, :polymorphic => true

  has_attached_file :image, :styles => { :thumb => "300x200#" }
end
