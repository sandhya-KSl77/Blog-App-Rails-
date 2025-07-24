FactoryBot.define do
    factory :article do
      title { "Test Article" }
      body  { "This is a valid article body with enough characters." } # > 30 chars
      association :user
    end
  end
  