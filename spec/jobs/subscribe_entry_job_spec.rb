require 'rails_helper'

RSpec.describe SubscribeEntryJob, type: :job do
  let(:entry) { double(:entry) }

  describe '#perform' do
    it 'delegates to EntrySubscriptionService' do
      ActiveJob::Base.queue_adapter = :test

      service = double(:service)
      expect(Services::SubscribeEntryService).to receive(:new).with(entry).and_return(service)
      expect(service).to receive(:run)

      described_class.perform_now(entry)
    end
  end
end
