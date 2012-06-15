module UserHelper
  include Devise::TestHelpers
  
  # gives us the login_as(@user) method when request object is not present
  include Warden::Test::Helpers
  Warden.test_mode!

  def as(resource=nil, &block)
    @current_user = create(resource.to_sym)
    if request.present?
      sign_in(@current_user)
    else
      login_as(@current_user, :scope => resource)
    end
    block.call if block.present?
    # return self
    return @current_user
  end
  
  def as_guest(resource=nil, &block)
    current_resource = resource || Factory.stub(resource.to_sym)
    if request.present?
      sign_out(current_resource)
    else
      logout(:user)
    end
    block.call if block.present?
    return self
  end

  # Will run the given code as the user passed in
  def as_user(user=nil, &block)
    current_user = user || Factory.create(:user)
    if request.present?
      sign_in(current_user)
    else
      login_as(current_user, :scope => :user)
    end
    block.call if block.present?
    return self
  end


  def as_visitor(user=nil, &block)
    current_user = user || Factory.stub(:user)
    if request.present?
      sign_out(current_user)
    else
      logout(:user)
    end
    block.call if block.present?
    return self
  end
end