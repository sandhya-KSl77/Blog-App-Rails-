class Article < ApplicationRecord
    belongs_to :user
    validates :user, presence: true
    validates :title, presence: true, length: { minimum: 3 }
    validates :body, presence: true, length: { minimum: 30 }
    has_one_attached :image
    has_many :comments, dependent: :destroy
    has_many :commenters, -> { distinct }, through: :comments, source: :user
    has_many :likes, dependent: :destroy

    def likes_count
      likes.where(like_type: 'like').count
    end

    def dislikes_count
      likes.where(like_type: 'dislike').count
    end
  end
  