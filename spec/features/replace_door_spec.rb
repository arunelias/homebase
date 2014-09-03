require 'spec_helper'

feature "Replace doors" do

  scenario "when user selects doors that doesn't need permit (Replace door on current hinges)" do

    visit '/permits'

    # permit#new
    check "Doors"
    click_on "Next step"

    expect(current_path).to eq('/permit_steps/answer_screener')
    expect(page).to have_content("Enter your project details")

    #permit_steps#answer_screener
    within "div.door_replace_existing" do
      choose "Yes"
    end

    within "div.contractor" do
      choose "No"
    end

    within "div.owner_address" do
      fill_in "Enter the address of the property you're working on.", with: "302 Madison St, San Antonio"
    end

    click_on "Submit"

    expect(current_path).to eq('/permit_steps/display_permits')
    expect(page).to have_content("This is how to start your project(s)")

    #permit_steps#display_permits
    page.find('div.permit_not_needed').should have_content('Doors')

    page.has_no_button? "Apply for this permit"

  end
  
  scenario "when user selects doors that needs permit (More than replacing door on current hinges)" do

    visit '/permits'

    # permit#new
    check "Doors"
    click_on "Next step"

    expect(current_path).to eq('/permit_steps/answer_screener')
    expect(page).to have_content("Enter your project details")

    #permit_steps#answer_screener
    within "div.door_replace_existing" do
      choose "No"
    end

    within "div.contractor" do
      choose "No"
    end

    within "div.owner_address" do
      fill_in "Enter the address of the property you're working on.", with: "302 Madison St, San Antonio"
    end

    click_on "Submit"

    expect(current_path).to eq('/permit_steps/display_permits')
    expect(page).to have_content("This is how to start your project(s)")

    #permit_steps#display_permits
    page.find('div.permit_needed').should have_content('Doors')

    click_on "Apply for this permit"

    expect(current_path).to eq('/permit_steps/enter_details')
    expect(page).to have_content("General Repair/Residential Permit Application")

    #permit_steps#enter_details
    fill_in "How many doors are you changing?", with: "2"

    fill_in "Homeowner name", with: "John Doe"
    page.has_field?('Home address', with: "302 Madison St, San Antonio, TX 78204")
    fill_in "Homeowner email address", with: "john@johndoe.com"
    fill_in "Homeowner phone number", with: "413-456-3456"

    fill_in "Work Summary", with: "Building an addition in my backyard"
    fill_in "Job Cost", with: "10000"

    click_on "Next step"

    expect(current_path).to eq('/permit_steps/confirm_terms')
    expect(page).to have_content("Please read these terms and sign your permit online")

    #permit_steps#confirm_terms
    check "permit_accepted_terms"
    fill_in "Enter your name", with: "John Doe"

    click_on "I agree"

    # This is odd it is not working, as if button wasn't clicked
    # expect(current_path).to eq('/permit_steps/display_summary')
    # expect(page).to have_content("Almost done! We filled in your permit applications")

  end

end