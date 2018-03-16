class AddMailchimpColumnsToCompetitions < ActiveRecord::Migration
  def change
    raise("Drop competitions before migrating") if Competition.any?
    add_column :competitions, :mailchimp_api_key, :string
    add_column :competitions, :mailchimp_list_id, :string

    change_column :competitions, :mailchimp_api_key, :string, null: false
    change_column :competitions, :mailchimp_list_id, :string, null: false
  end
end
