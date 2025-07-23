class Subscription < ApplicationRecord
  belongs_to :user
  validates :plan, inclusion: { in: ['basic', 'professional', 'elite'] }
end
