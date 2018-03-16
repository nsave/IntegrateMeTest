class MailchimpListsController < ApplicationController

  # It is actualy POST to hide api_key from logs
  def index
    mailchimp_lists = MailchimpGateway.new(params[:api_key]).get_lists

    render json: { lists: mailchimp_lists }
  end
end
