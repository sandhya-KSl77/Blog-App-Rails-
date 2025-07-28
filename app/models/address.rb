class Address < ApplicationRecord
  belongs_to :addressable, polymorphic: true
  def self.ransackable_attributes(auth_object = nil)
    %w[id line1 line2 city zip address_type addressable_id addressable_type created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
