class Like < ApplicationRecord

  def self.ransackable_attributes(auth_object = nil)
    %w[id user_id article_id created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user article]
  end

  belongs_to :user
  belongs_to :article

  validates :like_type, inclusion: { in: %w[like dislike] }
  validates :user_id, uniqueness: { scope: :article_id } 
end
