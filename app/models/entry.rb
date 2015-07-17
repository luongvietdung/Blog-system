class Entry < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  
  has_many :comments
  
  validates :title, presence: true, length: {minimum: 10}
  validates :body, presence: true, length: {minimum: 255}
end
