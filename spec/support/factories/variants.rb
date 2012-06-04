# FactoryGirl.define do
#   factory :variant do
#     price 20
#     # product { |p| p.association(:product) }
#     # option_values { [create(:option_value)] }
#   end
#   
#   factory :variant_with_image, :parent => :variant do
#     image { File.open(File.join(Rails.root, 'spec', 'support', 'assets', 'keyboard.jpg')) }
#   end
# end
