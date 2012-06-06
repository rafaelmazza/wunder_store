require 'spec_helper'

describe AttachmentUploader do
  include CarrierWave::Test::Matchers
  
  before do
    AttachmentUploader.enable_processing = true
    @variant = Variant.new
    @uploader = AttachmentUploader.new(@variant, :image)
    image_path = File.expand_path(Rails.root.join('spec', 'support', 'assets', 'keyboard.jpg'))
    @uploader.store!(File.open(image_path))
  end
  
  after do
    AttachmentUploader.enable_processing = false
    @uploader.remove!
  end
  
  context "the thumb version" do
    it "should resize to fill by 300x225px" do
      @uploader.thumb.should have_dimensions(300, 225)
    end      
  end
end