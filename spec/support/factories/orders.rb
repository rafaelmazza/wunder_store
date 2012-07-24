FactoryGirl.define do
  factory :order do
    first_name 'John'
    last_name 'Doe'
    # quantity 1
    # line_items [FactoryGirl.build(:line_item)]
    user
  end
end