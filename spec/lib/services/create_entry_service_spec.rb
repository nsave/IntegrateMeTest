require "rails_helper"

describe Services::CreateEntryService do
  let(:repository)    { double(:repository) }
  let(:valid_entry)   { double(:entry, valid?: true) }
  let(:invalid_entry) { double(:entry, valid?: false, errors: { key: [:val] }) }

  it 'creates a valid entry' do
    expect(repository).to        receive(:create).and_return(valid_entry)
    expect(SubscribeEntryJob).to receive(:perform_later)

    service = described_class.new(double(:params), repository).run

    expect(service.entry).to be(valid_entry)
    expect(service.errors).to be_empty
  end

  it 'fails to create an invalid entry' do
    expect(repository).to             receive(:create).and_return(invalid_entry)
    expect(SubscribeEntryJob).to_not  receive(:perform_later)

    service = described_class.new(double(:params), repository).run

    expect(service.entry).to be(invalid_entry)
    expect(service.errors).to_not be_empty
  end
end