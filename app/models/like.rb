class Like < ApplicationRecord
  belongs_to :user
  belongs_to :article

  validates :like_type, inclusion: { in: %w[like dislike] }
  validates :user_id, uniqueness: { scope: :article_id } 
end
