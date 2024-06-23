class AddFileReferenceToDebts < ActiveRecord::Migration[7.1]
  def change
    add_reference :debts, :uploaded_file, null: false, foreign_key: true
  end
end
