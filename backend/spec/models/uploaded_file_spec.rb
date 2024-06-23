# == Schema Information
#
# Table name: uploaded_files
#
#  id         :bigint           not null, primary key
#  filename   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe UploadedFile, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
