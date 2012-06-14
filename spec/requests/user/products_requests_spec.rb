require 'spec_helper'

describe "User products requests" do
  before do
    as(:user)
  end
  
  it "creates a product" do
    product = build(:product)
    visit products_path
    click_on "New Product"      
    fill_in "Name", :with => product.name
    fill_in "Description", :with => product.description
    fill_in "Price", :with => product.price
    click_on "Save"
    current_path.should == products_path
    page.should have_content(product.name)
  end
  
  it "edit a product" do
    product = create(:product)
    visit products_path
    # within "ul li.product ul li" do
      click_on "Edit"
    # end
    current_path.should == edit_product_path(product)
    # page.should have_content(product.name)
    fill_in "Name", :with => "#{product.name} edited"
    click_on "Save"
    current_path.should == products_path
    page.should have_content("#{product.name} edited")
  end
  
  it "show a product" do
    product = create(:product)
    visit products_path
    click_on "View"
    current_path.should == product_path(product)
    page.should have_content(product.name)
  end
  
  it "deletes a product" do
    product = create(:product)
    visit products_path
    click_on "Delete"
    current_path.should == products_path
    page.should_not have_content(product.name)
  end
  
  it "display product images when editing" do
    product = create(:product_with_image)
    visit edit_product_path(product)
    page.should have_xpath("//img[contains(@src, \"keyboard.jpg\")]")
  end
  
  context "uploading product images" do
    it "uploads a product image", :js => true do
      visit products_path
      click_on "New Product"      
      fill_in "Name", :with => "Keyboard"
      fill_in "Description", :with => "A great keyboard."
      fill_in "Price", :with => 19.99
      
      click_on "Add Image"
      absolute_path = File.expand_path(Rails.root.join('spec', 'support', 'assets', 'keyboard.jpg'))
      attachment_id = page.find(".attachment input")[:id]
      attach_file(attachment_id, absolute_path)
      
      click_on "Save"
      current_path.should == products_path
      page.should have_xpath("//img[contains(@src, \"keyboard.jpg\")]")
    end
  end
end