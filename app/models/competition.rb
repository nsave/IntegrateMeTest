class Competition < ActiveRecord::Base
  has_many :entries, inverse_of: :competition

  validates_presence_of :name, :mailchimp_api_key, :mailchimp_list_id
end
