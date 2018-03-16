require "rails_helper"

describe Competition do
  it "should require a name" do
    expect {
      Competition.create!(name: nil, mailchimp_api_key: :key, mailchimp_list_id: :id)
    }.to raise_error(ActiveRecord::RecordInvalid)
  end
end