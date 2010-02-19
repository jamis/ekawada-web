class Illustration < ActiveRecord::Base
  belongs_to :parent, :polymorphic => true

  has_attached_file :image, :styles => { :original => "1024x1024", :thumb => "300x200#" }
end
