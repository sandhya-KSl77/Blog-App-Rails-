FactoryBot.define do
    factory :comment do
      body { "Nice article!" }
      association :user
      association :article
    end
  end
  