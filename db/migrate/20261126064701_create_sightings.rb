class CreateSightings < ActiveRecord::Migration[8.1]
  def change
    create_table :sightings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :area, null: false, foreign_key: true
      t.references :cat, null: true, foreign_key: true
      t.string :kind
      t.text :description
      t.string :status, default: "未確認", null: false

      t.timestamps
    end
  end
end