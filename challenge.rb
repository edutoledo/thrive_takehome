# frozen_string_literal: true

User = Struct.new(
  :id,
  :first_name,
  :last_name,
  :email,
  :company_id,
  :email_status,
  :active_status,
  :tokens
)

Company = Struct.new(:id, :name, :top_up, :email_status)

def parse_users(users)
  users.map do |user|
    User.new(
      user['id'], user['first_name'], user['last_name'], user['email'], user['company_id'],
      user['email_status'], user['active_status'], user['tokens']
    )
  end
end

def parse_companies(companies)
  companies.map do |company|
    Company.new(company['id'], company['name'], company['top_up'], company['email_status'])
  end
end
