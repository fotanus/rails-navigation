require 'rails_helper'

RSpec.describe "rspec_models/new", :type => :view do
  before(:each) do
    assign(:rspec_model, RspecModel.new(
      :name => "MyString"
    ))
  end

  it "renders new rspec_model form" do
    render

    assert_select "form[action=?][method=?]", rspec_models_path, "post" do

      assert_select "input#rspec_model_name[name=?]", "rspec_model[name]"
    end
  end
end
