# frozen_string_literal: true

require 'pry'

User = Struct.new(:id, :first_name, :last_name, :email, :company_id, :email_status, :active_status, :tokens)

def parse_users(users)
  users.map do |user|
    # binding.pry
    User.new(
      user['id'], user['first_name'], user['last_name'], user['email'], user['company_id'],
      user['email_status'], user['active_status'], user['tokens']
    )
  end
end
