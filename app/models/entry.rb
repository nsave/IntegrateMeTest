class Entry < ActiveRecord::Base
  EMAIL_REGEX = /\A[A-Z0-9._%a-z\-+]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,12}\z/

  belongs_to :competition

  before_validation :clean_email

  validates_presence_of :competition, inverse_of: :entries
  validates_presence_of :email
  validates_format_of :email, :with => EMAIL_REGEX, allow_blank: true, allow_nil: true
  validates_presence_of :name, if: :requires_name
  validates_uniqueness_of :email, scope: :competition, message: "has already entered this competition"

  scope :not_subscribed, ->() { where(subscribed_at: nil) }

  delegate :mailchimp_api_key, :mailchimp_list_id, to: :competition

  def subscribed?
    !!self.subscribed_at
  end

  def subscribed!
    self.update_column(:subscribed_at, Time.now)
  end

  private
    def clean_email
      self.email = email.downcase.strip if email.present?
    end

    def requires_name
      competition && competition.requires_entry_name?
    end
end
