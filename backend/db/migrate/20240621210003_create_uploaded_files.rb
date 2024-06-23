class CreateUploadedFiles < ActiveRecord::Migration[7.1]
  def change
    create_table :uploaded_files do |t|
      t.string :filename

      t.timestamps
    end
  end
end
