require 'spec_helper'

describe "routing to bulky" do
  it "routes GET /bulky/:model/edit to bulky/updates#edit" do
    expect(get: '/bulky/accounts/edit').to route_to(
      controller: 'bulky/updates',
      action:     'edit',
      model:      'accounts'
    )
  end

  it "routes PUT /bulky/:model to bulky/updates#update" do
    expect(put: '/bulky/accounts').to route_to(
      controller: 'bulky/updates',
      action:     'update',
      model:      'accounts'
    )
  end
end
