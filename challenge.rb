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

def parse_and_filter_users(users)
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

# No specs written for this method since it does simple things, reading a file, parsing JSON,
# and calling 2 other methods that are already covered by specs.
def read_and_parse_users_and_companies(users_filename, companies_filename)
  [
    parse_users(JSON.parse(File.read(users_filename))),
    parse_companies(JSON.parse(File.read(companies_filename)))
  ]
  # TODO: Both file read and json parse can raise errors, handle those
end
