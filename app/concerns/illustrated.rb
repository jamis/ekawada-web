module Illustrated
  def self.included(base)
    base.has_many :illustrations, :as => :parent, :order => "number", :dependent => :destroy do
      def next_number
        (map(&:number).compact.max || 0) + 1
      end
    end

    base.after_save :update_illustrations
  end

  attr_writer :old_illustrations, :new_illustrations

  def old_illustrations
    @old_illustrations || {}
  end

  def new_illustrations
    @new_illustrations || []
  end

  private # --------------------------------------------------------------

  def update_illustrations
    list = old_illustrations.values + new_illustrations
    self.old_illustrations = self.new_illustrations = nil

    list.each do |hash|
      if hash[:id]
        i = illustrations.find(hash[:id])
        if hash.delete(:delete).to_i == 1
          i.destroy
        else
          i.update_attributes(hash)
        end
      else
        illustrations.create(hash)
      end
    end
  end
end
