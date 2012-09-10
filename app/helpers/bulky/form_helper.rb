module Bulky
  module FormHelper

    def whitelisted_attributes_collection(model)
      model.accessible_attributes.select(&:present?).map {|a| [a.titleize, a]}
    end

  end
end
