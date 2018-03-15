module Services
  class CreateEntryService
    attr_reader :errors, :entry

    def initialize(entry_params)
      @errors = {}
      @entry  = Entry.new(entry_params)
    end

    def run
      if @entry.save
        subscribe_entry(@entry)
      else
        @errors.merge!(@entry.errors.as_json)
      end

      return self
    end

    protected

    def subscribe_entry(entry)
      SubscribeEntryJob.perform_later(entry)
    end
  end
end
