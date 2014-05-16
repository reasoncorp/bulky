module Bulky
  module FormHelper

    def whitelisted_attributes_collection(model)
      model.bulky_attributes.map(&:to_s).map {|a| [a.titleize, a]}
    end

  end
end
