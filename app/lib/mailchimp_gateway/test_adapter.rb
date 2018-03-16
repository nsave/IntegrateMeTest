class MailchimpGateway::TestAdapter
  def initialize(_); end

  def get_lists
    []
  end

  def create_member(*_)
    false
  end

  def search_members(*_)
    []
  end
end
