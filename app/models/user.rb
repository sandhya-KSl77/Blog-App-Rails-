class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable,
         authentication_keys: [:username]

  validates :username, presence: { message: "can't be blank" }
  validates :username, uniqueness: { message: "already exists" }
  validates :username, format: {
    with: /\A[a-zA-Z0-9_]+\z/,
    message: "can only contain letters, numbers, and underscores"
  }

  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?
  has_many :likes, dependent: :destroy

  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end

  def email_required?
    false
  end

  def email_changed?
    false
  end
end
