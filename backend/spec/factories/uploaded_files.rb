# == Schema Information
#
# Table name: uploaded_files
#
#  id         :bigint           not null, primary key
#  filename   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :uploaded_file do
    filename { "input_light.csv" }
  end
end
