class User < ApplicationRecord
  before_create :set_default_role
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
  has_many :articles, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_one_attached :avatar
  has_many :addresses, as: :addressable, dependent: :destroy
  accepts_nested_attributes_for :addresses, allow_destroy: true
  ROLES = %w[admin editor normal_user]
  validates :role, inclusion: { in: ROLES }
  
  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end

  def email_required?
    false
  end

  def email_changed?
    false
  end

  def billing_address
    addresses.find { |a| a.address_type == "billing" }
  end

  def mailing_address
    addresses.find { |a| a.address_type == "mailing" }
  end

  def admin?
    role == 'admin'
  end

  def editor?
    role == 'editor'
  end

  def normal_user?
    role == 'normal_user'
  end

  private

  def set_default_role
    self.role ||= 'normal_user'
  end
end
