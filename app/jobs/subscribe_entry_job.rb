class SubscribeEntryJob < ActiveJob::Base
  queue_as :default

  def perform(entry)
    Services::SubscribeEntryService.new(entry).run
  end
end
