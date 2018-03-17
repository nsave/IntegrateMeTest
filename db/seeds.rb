# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


{
    1 => {
      name: "Name+Email comp", requires_entry_name: true, mailchimp_api_key: 'yourapikey', mailchimp_list_id: 'listid'
    },
    2 => {
      name: "Email only comp", requires_entry_name: false, mailchimp_api_key: 'yourapikey', mailchimp_list_id: 'listid'
    }
}.each_pair do |id, data|
  c = Competition.find_or_initialize_by(id: id)
  c.attributes = data
  c.save!
end