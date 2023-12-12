class Contact < ApplicationRecord
  belongs_to :employee

  validates :phone, :mobile_phone, :email, presence: true
  validates :email, uniqueness: true
  validates :phone, :mobile_phone, uniqueness: {scope: :employee_id}
end
