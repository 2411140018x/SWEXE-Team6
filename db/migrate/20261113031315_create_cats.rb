class CreateCats < ActiveRecord::Migration[8.1]
  def change
    create_table :cats do |t|
      t.references :area, null: false, foreign_key: true
      t.string :name
      t.string :features
      t.string :sex
      t.boolean :ear_cut

      t.timestamps
    end
  end
end
