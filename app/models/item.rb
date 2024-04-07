class Item < ApplicationRecord
  belongs_to :list
  validates :list_id, presence: true
  validates :content, presence: true, length: { maximum: 50 }
end
