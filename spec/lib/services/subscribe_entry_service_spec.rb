require "rails_helper"

describe Services::SubscribeEntryService do
  let(:subscribed_entry)    { double(:entry, subscribed?: true) }
  let(:unsubscribed_entry)  { double(:entry, subscribed?: false, email: :email, name: 'name') }

  let(:subscription_gateway) { double(:fake_gateway) }

  it 'delegates subscription to a gateway' do
    expect(subscription_gateway).to receive(:create_member).and_return(true)
    expect(unsubscribed_entry).to   receive(:subscribed!)

    service = described_class.new(unsubscribed_entry, subscription_gateway).run

    expect(service.errors).to be_empty
  end

  it 'does not subscribe a subscribed entry' do
    expect(subscription_gateway).to_not receive(:create_member)
    expect(subscribed_entry).to_not     receive(:subscribed!)

    service = described_class.new(subscribed_entry, subscription_gateway).run

    expect(service.errors).to be_empty
  end

  it 'fails gracefully if gateway fails' do
    expect(subscription_gateway).to receive(:create_member).and_return(false)
    expect(unsubscribed_entry).to_not receive(:subscribed!)

    service = described_class.new(unsubscribed_entry, subscription_gateway).run

    expect(service.errors).to_not be_empty
  end

  describe 'name parsing' do
    it 'splits entry name' do
      entry = double(:entry, subscribed?: false, email: :email, name: 'Nick Save')
      expect(subscription_gateway).to receive(:create_member).with(:email, 'Nick', 'Save')
      described_class.new(entry, subscription_gateway).run
    end

    it 'it appends last name if needed' do
      entry = double(:entry, subscribed?: false, email: :email, name: 'Nick')
      expect(subscription_gateway).to receive(:create_member).with(:email, 'Nick', 'Unknown')
      described_class.new(entry, subscription_gateway).run
    end

    it 'it appends first and last name if needed' do
      entry = double(:entry, subscribed?: false, email: :email, name: nil)
      expect(subscription_gateway).to receive(:create_member).with(:email, 'Stranger', 'Unknown')
      described_class.new(entry, subscription_gateway).run
    end
  end
end