class Services::SubscribeEntryService
  attr_reader :errors

  DEFAULT_FIRST_NAME = 'Stranger'
  DEFAULT_LAST_NAME  = 'Unknown'

  def initialize(entry, subscription_gateway_factory = MailchimpGateway)
    @errors = {}
    @entry  = entry

    @subscription_gateway = subscription_gateway_factory.new(@entry.mailchimp_api_key)
  end

  def run
    unless @entry.subscribed?

      if subscribe(@entry) || search_existing(@entry)
        @entry.subscribed!
        Rails.logger.info("Mailchimp member subscribed (#{@entry.email})")
      else
        @errors[:internal_error] = nil
        Rails.logger.error("Failed to subscribe mailchimp member (#{@entry.email})")
      end

    end

    self
  end

  protected

  def subscribe(entry)
    @subscription_gateway.create_member(
      @entry.mailchimp_list_id,
      entry.email,
      *split_full_name(entry.name)
    )
  end

  def search_existing(entry)
    @subscription_gateway.search_members(
      @entry.mailchimp_list_id,
      email: entry.email
    ).any?
  end

  def split_full_name(full_name)
    if full_name.presence
      first_name, last_name = full_name.strip.split(/\s+/, 2)
      last_name ||= DEFAULT_LAST_NAME
    else
      first_name, last_name = DEFAULT_FIRST_NAME, DEFAULT_LAST_NAME
    end

    return first_name, last_name
  end
end
