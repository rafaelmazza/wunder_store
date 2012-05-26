require 'spec_helper'

describe "Products request" do
  it "creates a product" do
    visit products_path
    click_on "New Product"      
    fill_in "Name", :with => "Keyboard"
    fill_in "Description", :with => "A great keyboard."
    fill_in "Price", :with => 19.99
    # fill_in "product_variant1_name", :with => "Color"
    # fill_in "product_variant1_values", :with => "Black, White, Red"
    click_on "Save"
    current_path.should == products_path
    page.should have_content("Keyboard")
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
end