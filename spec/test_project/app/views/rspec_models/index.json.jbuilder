json.array!(@rspec_models) do |rspec_model|
  json.extract! rspec_model, :id, :name
  json.url rspec_model_url(rspec_model, format: :json)
end
