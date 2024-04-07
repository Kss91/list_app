class List < ApplicationRecord
  belongs_to :user
  has_many :items, dependent: :destroy
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 50 }
end
