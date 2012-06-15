require 'spec_helper'

describe "User products requests" do
  before do
    as(:user)
  end
  
  context 'list products' do
    it 'list only current user products' do
      another_user = create(:user)
      product_1 = create(:product, user: @current_user)
      product_2 = create(:product, user: another_user)
      product_3 = create(:product, user: another_user)
      visit products_path
      page.should have_content(product_1.name)
      page.should_not have_content(product_2.name)
      page.should_not have_content(product_3.name)
    end
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
    product = create(:product, user: @current_user)
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
    product = create(:product, user: @current_user)
    visit products_path
    click_on "View"
    current_path.should == product_path(product)
    page.should have_content(product.name)
  end
  
  it "deletes a product" do
    product = create(:product, user: @current_user)
    visit products_path
    click_on "Delete"
    current_path.should == products_path
    page.should_not have_content(product.name)
  end
  
  it "display product images when editing" do
    product = create(:product_with_image, user: @current_user)
    visit edit_product_path(product)
    page.should have_xpath("//img[contains(@src, \"keyboard.jpg\")]")
  end
  
  context 'edit product', edit: true do
    let(:product) { create(:product, user: create(:user)) }
      
    it 'can only edit his own products' do
      expect {
        visit edit_product_path(product)
      }.to raise_exception(CanCan::AccessDenied)
    end
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