FactoryGirl.define do
  factory :user do
    sequence(:email) {|n| "user#{n}@cafeazul.com.br"}
    password '123mudar'
    password_confirmation '123mudar'
    paypal_id 'paypal_id'
  end
end
