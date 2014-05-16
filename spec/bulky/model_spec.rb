require 'spec_helper'

describe Bulky::Model do

  let(:example) { Class.new { extend Bulky::Model } }

  it "allows defining attributes for bulk update" do
    example.bulky :foo
    expect(example.bulky_attributes).to include :foo
  end

end

