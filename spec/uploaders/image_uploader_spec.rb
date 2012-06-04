require 'spec_helper'

describe ImageUploader do
  include CarrierWave::Test::Matchers
  
  before do
    ImageUploader.enable_processing = true
    @variant = Variant.new
    @uploader = ImageUploader.new(@variant, :image)
    absolute_path = File.expand_path(Rails.root.join('spec', 'support', 'assets', 'keyboard.jpg'))
    @uploader.store!(File.open(absolute_path)) 
  end
  
  after do
    ImageUploader.enable_processing = false
    @uploader.remove!
  end
  
  context "the thumb version" do
    it "should resize to fill by 300x225px" do
      @uploader.thumb.should have_dimensions(300, 225)
    end      
  end
end