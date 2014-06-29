class CreateRspecModels < ActiveRecord::Migration
  def change
    create_table :rspec_models do |t|
      t.string :name

      t.timestamps
    end
  end
end
