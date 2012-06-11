FactoryGirl.define do
  factory :variant do
    # price 20
    # product { |p| p.association(:product) }
    # option_values { [create(:option_value)] }
    product
  end
  
  factory :variant_with_image, :parent => :variant do
    # image { File.open(File.join(Rails.root, 'spec', 'support', 'assets', 'keyboard.jpg')) }
    images [FactoryGirl.build(:image)]
  end
end

FactoryGirl.define do
  sequence(:name) { |n| "Product #{n}" }

  factory :product do
    # name FactoryGirl.generate(:name)
    name
    description "Amazing product with lot of features"
    price 19.99
  end
  
  factory :product_with_variants, :parent => :product do |p|
    # associations :variants, []
    # variants [FactoryGirl.create(:variant), FactoryGirl.create(:variant)]
  end
  
  factory :product_with_option_type, :parent => :product do
    # after_create { |product| create(:option_type, :product_ids => [product.id])}
    option_types { [FactoryGirl.create(:option_type)] }
  end
  
  factory :product_with_image, :parent => :product do
    master FactoryGirl.build(:variant_with_image)
  end
end
