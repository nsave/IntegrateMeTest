class Services::SubscribeEntryService
  attr_reader :errors

  def initialize(entry, subscription_gateway = MailchimpGateway)
    @errors = {}
    @entry  = entry

    @subscription_gateway = subscription_gateway
  end

  def run
    if @subscription_gateway.create_member(@entry.email, *split_full_name(@entry.name))
    else
      @errors[:internal_error] = nil
    end

    return self
  end

  protected

  def split_full_name(full_name)
    if full_name.presence
      first_name, last_name = full_name.strip.split(/\s+/, 2)
    else
      first_name, last_name = nil, nil
    end

    return first_name, last_name
  end
end
