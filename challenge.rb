# frozen_string_literal: true

User = Struct.new(
  :first_name,
  :last_name,
  :email,
  :company_id,
  :email_status,
  :previous_tokens,
  :tokens
)

Company = Struct.new(:id, :name, :top_up, :email_status)

def parse_and_filter_users(users)
  users.map do |user|
    next unless user['active_status']

    User.new(
      user['first_name'], user['last_name'], user['email'],
      user['company_id'], user['email_status'], user['tokens']
    )
  end.compact
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
    parse_and_filter_users(JSON.parse(File.read(users_filename))),
    parse_companies(JSON.parse(File.read(companies_filename)))
  ]
  # TODO: Both file read and json parse can raise errors, handle those
end

def top_up_tokens(users, companies)
  users.map do |user|
    # Value not set before, this is the "quick and dirty" working code, refactoring will come larter
    user.tokens = user.previous_tokens
    companies.each do |company|
      next unless user.company_id == company.id

      user.tokens += company.top_up
      break
    end

    user
  end
end
