class MailchimpGateway
  DEFAULT_LIST_ID = ENV['MAILCHIMP_LIST_ID']

  def self.create_member(email, first_name, last_name)
    Gibbon::Request.lists(DEFAULT_LIST_ID).members.create(
      body: {
        email_address: email,
        merge_fields: { FNAME: first_name, LNAME: last_name },
        status: 'subscribed'
      }
    )

    return true
  rescue Gibbon::MailChimpError => e
    Rails.logger.error("Mailchimp failed to create a member: #{e.message}")
    return false
  end
end
