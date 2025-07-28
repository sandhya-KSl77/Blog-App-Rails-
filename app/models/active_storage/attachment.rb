class ActiveStorage::Attachment < ApplicationRecord
  belongs_to :record, polymorphic: true, inverse_of: :avatar_attachment

  def self.ransackable_attributes(auth_object = nil)
    %w[id name record_type record_id created_at]
  end
end
