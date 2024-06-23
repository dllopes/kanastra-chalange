class AddProcessedToDebts < ActiveRecord::Migration[7.1]
  def change
    add_column :debts, :processed, :boolean, default: false
  end
end
