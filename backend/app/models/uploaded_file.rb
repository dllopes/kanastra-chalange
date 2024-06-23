# == Schema Information
#
# Table name: uploaded_files
#
#  id         :bigint           not null, primary key
#  filename   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class UploadedFile < ApplicationRecord
  has_many :debts
end
