module RequestSpecHelpers
  include Rails.application.routes.url_helpers

  def login_as_admin_user(factory_options={})
    user = FactoryGirl.create(:admin_user, factory_options)
    login(user.email, user.password)
  end
  def login_as_standard_user(factory_options={})
    user = FactoryGirl.create(:user, factory_options)
    login(user.email, user.password)
  end

  #def confirm_the_popup_dialog
    #page.driver.browser.switch_to.alert.accept
  #end

  #def cancel_the_popup_dialog
    #page.driver.browser.switch_to.alert.dismiss
  #end

  #def login_as_user_with_email(email)
    #password = "secretpass123"
    #u = Factory(:user, :email => email, :password => password, :name => "Bob Smith")
    #login(email, password)
  #end

  def login(email=nil, password=nil)
    logout
    visit login_path
    fill_in_login_fields(email, password)
    click_button "Login"
  end

  def logout
    visit logout_path
  end

  def fill_in_login_fields(email=nil, password=nil)
    fill_in "email", :with => email
    fill_in "password", :with => password
  end

  #def fill_in_registration_fields(name="Johnny Appleseed", password="apples123", email="johnny@apple.com")
    #within "#user_form" do
      #fill_in "#user_name", :with => name
      #fill_in "#user_password", :with => password
      #fill_in "#user_password_confirmation", :with => password
    #end
  #end

  ## def fill_in_review_form
  ##   within "#firm_review_form" do
  ##     fill_in "#review_title", :with => "Test Review!"
  ##     fill_in "#review_content", :with => "Test Review!"
  ##     all
  ##     (1..3).each do |i|
  ##       find("#rating-#{i}").click
  ##     end
  ##   end
  ## end

  #def should_be_on(path)
    #page.current_path.should == path
  #end
  
  #def fill_in_the_following(fields={})
    #fields.each do |field, value|
      #fill_in field.to_s,  :with => value
    #end
  #end

  #def select_the_following(fields={})
    #fields.each do |field, value|
      #select value, :from => field
    #end
  #end
  
  def should_have_errors(*messages)
    within(:css, "#errorExplanation") do
      messages.each { |msg| page.should have_content(msg) }
    end
  end

  def form_should_have_errors(form_selector)
    within(:css, form_selector) do
      page.should have_selector ".alert-error"
    end
  end

  def form_should_not_have_errors(form_selector)
    within(:css, form_selector) do
      page.should_not have_selector ".alert-error"
    end
  end

  def should_have_inline_error_on(field_id)
    field_id = "##{field_id}" unless field_id[0] == "#"
    field = page.find("#{field_id}")
    puts "FIELD: #{field.inspect}"
    field['class'].include?('string').should be_true
    parent = field.parent
    parent.text.include?('inline-help').should be_true
  end

  def should_not_have_inline_error_on(field_id)
    field_id = "##{field_id}" unless field_id[0] == "#"
    field = page.find("#{field_id}")
    field['class'].include?('string').should be_true
    parent = field.parent
    parent.should have_content 'inline-help'
  end

  def should_have_submit_button(button_name)
    page.should have_css "input[type='submit'][value='#{button_name}']"
  end

  def should_not_have_submit_button(button_name)
    page.should_not have_css "input[type='submit'][value='#{button_name}']"
  end

  #def should_have_inline_error(container, message)
    #within(container) do
      #page.should have_css ".error", :text => message
    #end
  #end

  #def should_have_inline_errors(*messages)
    #messages.each do |msg|
      #page.should have_css ".inline-errors", :text => msg
    #end
  #end


  #def should_have_the_following(*contents)
    #contents.each do |content|
      #page.should have_content(content)
    #end
  #end
  
  def should_see(*contents)
    contents.each do |content|
      page.should have_content(content)
    end
  end

  def should_not_see(*contents)
    contents.each do |content|
      page.should_not have_content(content)
    end
  end

  def should_have_selector(selector)
    page.should have_css(selector)
  end

  def should_not_have_selector(selector)
    page.should_not have_css(selector)
  end

  def should_be_on(path)
    page.current_path.should == path
  end

  def should_not_be_on(path)
    page.current_path.should_not == path
  end

  [:notice, :success, :error, :warning, :alert].each do |name|
    define_method "should_have_flash_#{name}" do |message|
      name = :success if name == :notice
      within ".alert-#{name}" do
        page.should have_content message
      end
    end
    define_method "should_not_have_flash_#{name}" do
      page.should have_no_css(".alert-#{name}")
    end
  end

  def should_have_unauthorized_access_error
    should_have_flash_warning 'You are not authorized to access this page'
  end

end

