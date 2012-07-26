FactoryGirl.define do  
  factory :user do
    sequence(:email) {|n| "user#{n}@cafeazul.com.br"}
    password "123mudar"
    password_confirmation "123mudar"
    paypal_id "paypal_id"
  end
  
  factory :image do
    attachment { File.open(File.join(Rails.root, "spec", "support", "assets", "keyboard.jpg")) }
  end
  
  factory :line_item do
    variant
  end
  
  factory :option_type do
    name "Color"
  end
  
  factory :option_value do
    name "Black"
    option_type
  end
  
  factory :order do
    first_name "John"
    last_name "Doe"
    user
  end
  
  factory :payment do
    amount 10
    order
  end

  factory :variant do
    product
    
    factory :variant_with_image, :parent => :variant do
      images [FactoryGirl.build(:image)]
    end
    
    # factory :variant_with_images do
    #   ignore do
    #     images_count 3
    #   end
    #   
    #   after(:create) do |variant, evaluator|
    #     FactoryGirl.create_list(:image, evaluator.images_count, variant: variant)
    #   end
    # end
  end

  factory :product do
    sequence(:name) { |n| "Product #{n}" }
    description "Amazing product with lot of features"
    price 19.99
    
    factory :product_with_image do
      master FactoryGirl.build(:variant_with_image)
    end
  end
end