class AddSubscribedAtToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :subscribed_at, :datetime
  end
end
