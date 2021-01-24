FactoryBot.define do
  factory :task do
    body {Faker::Name.name}
  end
end
