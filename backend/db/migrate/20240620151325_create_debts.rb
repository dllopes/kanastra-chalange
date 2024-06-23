class CreateDebts < ActiveRecord::Migration[7.1]
  def change
    create_table :debts do |t|
      t.string :name, null: false, limit: 256
      t.integer :government_id, null: false
      t.string :email, null: false, limit: 100
      t.integer :debt_amount, null: false
      t.date :debt_due_date, null: false
      t.uuid :debt_id, null: false
    end
  end
end
