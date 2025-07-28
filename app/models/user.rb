class User < ApplicationRecord
  include AASM

  aasm column: 'status' do
    state :unverified, initial: true
    state :pending_address
    state :pending_address_approval
    state :start_subscription
    state :active
  
    event :verify_email do
      transitions from: :unverified, to: :pending_address
    end
  
    event :submit_address do
      transitions from: :pending_address, to: :pending_address_approval
    end
  
    event :approve_address do
      transitions from: :pending_address_approval, to: :start_subscription
    end
  
    event :activate_subscription do
      transitions from: :start_subscription, to: :active
    end
  end  

  def self.ransackable_attributes(auth_object = nil)
    [
      "id", "username", "email", "status", "role",
      "created_at", "updated_at"
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    [
      "addresses", "articles", "likes", "subscription"
    ]
  end

  def after_confirmation
    self.verify_email! if may_verify_email?
    UserMailer.with(user: self).welcome_email.deliver_later
  end

  before_validation :set_default_role, on: :create
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :confirmable,
         authentication_keys: [:username]

  validates :username, presence: { message: "can't be blank" }
  validates :username, uniqueness: { message: "already exists" }
  validates :username, format: {
    with: /\A[a-zA-Z0-9_]+\z/,
    message: "can only contain letters, numbers, and underscores"
  }

  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  has_many :articles, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_one_attached :avatar
  has_many :addresses, as: :addressable, dependent: :destroy
  accepts_nested_attributes_for :addresses, allow_destroy: true
  ROLES = %w[admin editor normal_user]
  validates :role, inclusion: { in: ROLES }
  attr_accessor :plan
  has_one :subscription, dependent: :destroy

  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end

  def email_required?
    true
  end

  def email_changed?
    true
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
