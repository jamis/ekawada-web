module Illustrated
  def self.included(base)
    base.has_many :illustrations, :as => :parent, :order => "number", :dependent => :destroy do
      def next_number
        (map(&:number).max || 0) + 1
      end
    end

    base.after_save :update_illustrations
    base.send :attr_writer, :illustrations
  end

  private # --------------------------------------------------------------

  def update_illustrations
    Array(@illustrations).each do |hash|
      if hash[:id]
        i = illustrations.find(hash[:id])
        if hash[:delete].to_i == 1
          i.destroy
        else
          i.update_attributes(hash)
        end
      else
        illustrations.create(hash)
      end
    end

    @illustrations = nil
  end
end
