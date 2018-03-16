class MailchimpGateway
  DEFAULT_LIST_ID = ENV['MAILCHIMP_LIST_ID']

  def initialize(api_key)
    @request = Gibbon::Request.new(api_key: api_key)
  end

  def get_lists
    @request.lists.retrieve.body.
      fetch('lists', [])
  rescue Gibbon::MailChimpError, Gibbon::GibbonError => e
    Rails.logger.error("Mailchimp failed to retreive lists: #{e.message}")
    return []
  end

  def self.create_member(email, first_name, last_name)
    Gibbon::Request.lists(DEFAULT_LIST_ID).members.create(
      body: {
        email_address: email,
        merge_fields: { FNAME: first_name, LNAME: last_name },
        status: 'subscribed'
      }
    )

    return true
  rescue Gibbon::MailChimpError, Gibbon::GibbonError => e
    Rails.logger.error("Mailchimp failed to create a member: #{e.message}")
    return false
  end


  def self.search_members(email:)
    response = Gibbon::Request.search_members.retrieve(
      params: {
        query:    email,
        list_id:  DEFAULT_LIST_ID
      }
    )

    return response.body.
      fetch('exact_matches', {}).
      fetch('members', [])

  rescue Gibbon::MailChimpError, Gibbon::GibbonError => e
    Rails.logger.error("Mailchimp failed to retreive members: #{e.message}")
    return []
  end
end
