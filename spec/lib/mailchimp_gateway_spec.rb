require "rails_helper"

describe MailchimpGateway do
  subject { described_class.new('api-key') }

  describe '#create_member' do
    it 'returns true for successful request' do
      stub = stub_request(:post, "https://key.api.mailchimp.com/3.0/lists/test_id/members").
        with(
          body: {
            email_address: 'some@email.com',
            status: 'subscribed',
            merge_fields: {
              FNAME: 'fname',
              LNAME: 'lname',
            }
          }
      ).to_return(status: 200, body: "", headers: {})

      expect(
        subject.create_member(:test_id, 'some@email.com', 'fname', 'lname')
      ).to be_truthy

      expect(stub).to have_been_requested
    end

    it 'returns false for failed request' do
      stub = stub_request(:post, "https://key.api.mailchimp.com/3.0/lists/test_id/members").
        to_return(status: 400, body: "", headers: {})

      expect(
        subject.create_member(:test_id, 'some@email.com', 'fname', 'lname')
      ).to be_falsey
      expect(stub).to have_been_requested
    end
  end

  describe '#search_members' do
    it 'returns members array for successful request' do
      response_members = [{'key' => 'val'}]

      stub = stub_request(:get, "https://key.api.mailchimp.com/3.0/search-members?list_id=test_id&query=some@email.com").
        to_return(
          status: 200,
          body: { exact_matches: { members: response_members } }.to_json,
          headers: {}
        )

      expect(
        subject.search_members(:test_id, email: 'some@email.com')
      ).to eq(response_members)

      expect(stub).to have_been_requested
    end

    it 'returns empty array for failed request' do
      stub = stub_request(:get, "https://key.api.mailchimp.com/3.0/search-members?list_id=test_id&query=some@email.com").
        to_return(
          status: 400,
          body: "",
          headers: {}
        )

      expect(
        subject.search_members(:test_id, email: 'some@email.com')
      ).to eq([])

      expect(stub).to have_been_requested
    end
  end
end