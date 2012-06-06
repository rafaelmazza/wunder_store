FactoryGirl.define do
  factory :image do
    attachment { File.open(File.join(Rails.root, 'spec', 'support', 'assets', 'keyboard.jpg')) }
  end
end