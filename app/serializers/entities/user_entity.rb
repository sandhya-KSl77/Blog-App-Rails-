module Entities
    class UserEntity < Grape::Entity
      expose :id
      expose :email
      expose :username
      expose :role
      expose :status
    end
  end
  