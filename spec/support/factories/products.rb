FactoryGirl.define do
  sequence(:name) { |n| "Product #{n}" }

  factory :product do
    # name FactoryGirl.generate(:name)
    name
    description "Amazing product with lot of features"
    price 19.99
  end
  
  factory :product_with_option_type, :parent => :product do
    # after_create { |product| create(:option_type, :product_ids => [product.id])}
    option_types { [FactoryGirl.create(:option_type)] }
  end
end
