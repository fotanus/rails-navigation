require 'rails_helper'

RSpec.describe "rspec_models/edit", :type => :view do
  before(:each) do
    @rspec_model = assign(:rspec_model, RspecModel.create!(
      :name => "MyString"
    ))
  end

  it "renders the edit rspec_model form" do
    render

    assert_select "form[action=?][method=?]", rspec_model_path(@rspec_model), "post" do

      assert_select "input#rspec_model_name[name=?]", "rspec_model[name]"
    end
  end
end
