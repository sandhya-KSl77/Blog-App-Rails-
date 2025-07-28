class ActiveStorage::Blob < ApplicationRecord
  belongs_to :record, polymorphic: true, inverse_of: :avatar_attachment

    def self.ransackable_attributes(auth_object = nil)
      %w[id key filename content_type metadata byte_size checksum created_at]
    end
  end