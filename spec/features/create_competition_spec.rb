
require 'rails_helper'

feature 'Create competition' do
  before(:each) do
    WebMock.disable_net_connect!(allow_localhost: true)
  end

  scenario 'straightforward' do
    allow_any_instance_of(MailchimpGateway).to receive(:get_lists).and_return(
      [{id: 'test_id', name: 'test_name'}]
    )

    visit root_path

    click_on 'Create competition'
    click_on 'Cancel'
    click_on 'Create competition'

    fill_in 'Your api key', with: 'testkey'
    click_on 'Fetch!'

    sleep(1)

    select 'test_name', from: 'listsSelect'
    fill_in 'Name', with: 'New competition'
    click_on 'Create!'

    sleep(1)

    expect(page).to have_link('New competition')
  end

  scenario 'with invalid api key' do
    allow_any_instance_of(MailchimpGateway).to receive(:get_lists).and_return(
      []
    )

    visit root_path
    click_on 'Create competition'
    fill_in 'Your api key', with: 'testkey'
    click_on 'Fetch!'

    sleep(1)

    expect(page).to have_text('Sorry, ther was a problem')
  end

  scenario 'with empty name' do
    allow_any_instance_of(MailchimpGateway).to receive(:get_lists).and_return(
      [{id: 'test_id', name: 'test_name'}]
    )

    visit root_path
    click_on 'Create competition'
    fill_in 'Your api key', with: 'testkey'
    click_on 'Fetch!'

    sleep(1)

    select 'test_name', from: 'listsSelect'
    fill_in 'Name', with: '  '
    click_on 'Create!'

    sleep(1)

    expect(page).to have_text('Sorry, ther was a problem')
  end
end