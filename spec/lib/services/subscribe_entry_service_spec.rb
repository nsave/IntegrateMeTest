require "rails_helper"

describe Services::SubscribeEntryService do
  let(:subscribed_entry)    do
    double(:entry,
      subscribed?: true,
      mailchimp_api_key: 'test-key',
      mailchimp_list_id: :test_id
    )
  end

  let(:unsubscribed_entry) do
    double(:entry,
      subscribed?: false,
      email: :email,
      name: 'name',
      mailchimp_api_key: 'test-key',
      mailchimp_list_id: :test_id
    )
  end

  let(:gateway_factory) { MailchimpGateway::TestAdapter }

  it 'delegates subscription to a gateway' do
    expect_any_instance_of(gateway_factory).to  receive(:create_member).and_return(true)
    expect(unsubscribed_entry).to               receive(:subscribed!)

    service = described_class.new(unsubscribed_entry, gateway_factory).run

    expect(service.errors).to be_empty
  end

  it 'sets entry subscribed if its registered in the gateway' do
    expect_any_instance_of(gateway_factory).to receive(:create_member).and_return(false)
    expect_any_instance_of(gateway_factory).
      to receive(:search_members).with(:test_id, email: :email).
      and_return([:member])

    expect(unsubscribed_entry).to receive(:subscribed!)

    service = described_class.new(unsubscribed_entry, gateway_factory).run

    expect(service.errors).to be_empty
  end

  it 'does not subscribe a subscribed entry' do
    expect_any_instance_of(gateway_factory).to_not receive(:create_member)
    expect(subscribed_entry).to_not receive(:subscribed!)

    service = described_class.new(subscribed_entry, gateway_factory).run

    expect(service.errors).to be_empty
  end

  it 'fails gracefully if gateway fails' do
    expect_any_instance_of(gateway_factory).to receive(:create_member).and_return(false)
    expect(unsubscribed_entry).to_not receive(:subscribed!)

    service = described_class.new(unsubscribed_entry, gateway_factory).run

    expect(service.errors).to_not be_empty
  end

  describe 'name parsing' do
    def build_entry(name)
      double(:entry,
        subscribed?: false,
        email: :email,
        name: name,
        mailchimp_api_key: :test_key,
        mailchimp_list_id: :test_id
      )
    end
    it 'splits entry name' do
      entry = build_entry('Nick Save')
      expect_any_instance_of(gateway_factory).
        to receive(:create_member).
        with(:test_id, :email, 'Nick', 'Save')

      described_class.new(entry, gateway_factory).run
    end

    it 'it appends last name if needed' do
      entry = build_entry('Nick')
      expect_any_instance_of(gateway_factory).
        to receive(:create_member).
        with(:test_id, :email, 'Nick', 'Unknown')

      described_class.new(entry, gateway_factory).run
    end

    it 'it appends first and last name if needed' do
      entry = build_entry(nil)
      expect_any_instance_of(gateway_factory).
        to receive(:create_member).
        with(:test_id, :email, 'Stranger', 'Unknown')

      described_class.new(entry, gateway_factory).run
    end
  end
end