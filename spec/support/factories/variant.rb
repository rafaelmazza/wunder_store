FactoryGirl.define do
  factory :variant do
    price 20
    product { |p| p.association(:product) }
    option_values { [create(:option_value)] }
  end
end