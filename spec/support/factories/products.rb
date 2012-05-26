FactoryGirl.define do
  sequence(:name) { |n| "Product #{n}" }

  factory :product do
    name FactoryGirl.generate(:name)
    description "Amazing product with lot of features"
    price 19.99
  end
end
