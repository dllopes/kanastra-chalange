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
class Debt < ApplicationRecord
  belongs_to :uploaded_file
end
