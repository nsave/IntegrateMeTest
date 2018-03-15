module Services
  class CreateEntryService
    attr_reader :errors, :entry

    def initialize(entry_params, repository = Entry)
      @entry_params = entry_params
      @repository   = repository

      @errors = {}
      @entry  = nil
    end

    def run
      @entry = @repository.create(@entry_params)

      if @entry.valid?
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
