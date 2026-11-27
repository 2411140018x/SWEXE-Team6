class AddRoleToUsers < ActiveRecord::Migration[8.1]
  def change
    # README のデータモデルどおり、アカウントの種類（世話人／住民／市の職員）を持たせる
    add_column :users, :role, :string, null: false, default: "住民"
  end
end
