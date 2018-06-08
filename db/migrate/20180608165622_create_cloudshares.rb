class CreateCloudshares < ActiveRecord::Migration[5.1]
  def change
    create_table :cloudshares do |t|

      t.timestamps
    end
  end
end
