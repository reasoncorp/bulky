module Bulky
  module Model

    def self.extended(base)
      base.class_attribute :bulky_attributes
      base.bulky_attributes = []
    end

    def bulky(*attributes)
      self.bulky_attributes += attributes
    end

  end
end
