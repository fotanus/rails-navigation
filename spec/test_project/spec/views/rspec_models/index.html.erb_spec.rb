require 'rails_helper'

RSpec.describe "rspec_models/index", :type => :view do
  before(:each) do
    assign(:rspec_models, [
      RspecModel.create!(
        :name => "Name"
      ),
      RspecModel.create!(
        :name => "Name"
      )
    ])
  end

  it "renders a list of rspec_models" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
