require 'rails_helper'

RSpec.describe "rspec_models/show", :type => :view do
  before(:each) do
    @rspec_model = assign(:rspec_model, RspecModel.create!(
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
  end
end
