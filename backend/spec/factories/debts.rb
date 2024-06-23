# == Schema Information
#
# Table name: debts
#
#  id               :bigint           not null, primary key
#  name             :string(256)      not null
#  government_id    :integer          not null
#  email            :string(100)      not null
#  debt_amount      :integer          not null
#  debt_due_date    :date             not null
#  debt_id          :uuid             not null
#  uploaded_file_id :bigint           not null
#  processed        :boolean          default(FALSE)
#

FactoryBot.define do
  factory :debt do
    name { "John Doe" }
    government_id { "1234" }
    email { "john.doe@example.com" }
    debt_amount { 1000 }
    debt_due_date { "2023-12-31" }
    debt_id { SecureRandom.uuid }
    processed { false }
    association :uploaded_file
  end
end