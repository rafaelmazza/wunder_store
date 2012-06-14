FactoryGirl.define do
  factory :user do
    sequence(:email) {|n| "user#{n}@cafeazul.com.br"}
    password '123mudar'
    password_confirmation '123mudar'
  end
end
