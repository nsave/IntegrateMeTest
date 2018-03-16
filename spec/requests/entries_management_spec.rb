require "rails_helper"

RSpec.describe "Entries management", type: :request do
  before(:each) do
    stub_const('MailchimpGateway::DEFAULT_LIST_ID', 'list_id')
    stub_request(:post, "https://key.api.mailchimp.com/3.0/lists/list_id/members").
      to_return(status: 200, body: "", headers: {})
  end

  before(:all) do
    @competition_1 = Competition.create(
      name: "Name+Email comp",
      requires_entry_name: true,
      mailchimp_api_key: :test_key_1,
      mailchimp_list_id: :test_list_1
    )
    @competition_2 = Competition.create(
      name: "Email only comp",
      requires_entry_name: false,
      mailchimp_api_key: :test_key_2,
      mailchimp_list_id: :test_list_2
    )
  end

  describe 'for competition with name required' do
    it 'responds with error for missing name' do
      post "/entries", {
        entry: {
          competition_id: @competition_1.id,
          email: 'some@email.com'
        }
      }

      expect(JSON.parse(response.body)).to include("errors", "success" => false)
    end

    it 'responds with success' do
      post "/entries", {
        entry: {
          competition_id: @competition_1.id,
          email: 'some@email.com',
          name: 'somename'
        }
      }

      expect(JSON.parse(response.body)).to include("success" => true)
    end
  end

  describe 'for competition without name required' do
    it 'responds with error for invalid email' do
      post "/entries", {
        entry: {
          competition_id: @competition_2.id,
          email: 'someinvalidemail'
        }
      }

      expect(JSON.parse(response.body)).to include("errors", "success" => false)
    end

    it 'responds with success' do
      post "/entries", {
        entry: {
          competition_id: @competition_2.id,
          email: 'some@email.com'
        }
      }

      expect(JSON.parse(response.body)).to include("success" => true)
    end
  end

end