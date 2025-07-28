class Subscription < ApplicationRecord
  belongs_to :user
  validates :plan, inclusion: { in: ['basic', 'professional', 'elite'] }
  def self.ransackable_attributes(auth_object = nil)
    %w[id user_id plan stripe_id status created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user]
  end
end
