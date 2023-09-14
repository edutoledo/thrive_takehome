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

def group_and_categorize_company_users(_users, _companies)
  nil
end

def print_company(company, users)
  # For now the users received will be all users, after refactoring it will be cleaner
  output = "\n\tCompany Id: #{company.id}"
  output += "\n\tCompany Name: #{company.name}"
  output += "\n\tUsers Emailed:"

  emailed_users = []
  not_emailed_users = []

  if company.email_status
    users.each do |user|
      next unless user.company_id == company.id

      if user.email_status
        emailed_users << user
      else
        not_emailed_users << user
      end
    end
  else
    not_emailed_users = users.filter do |user|
      user.company_id == company.id
    end
  end
  emailed_users.sort! { |a, b| a.last_name <=> b.last_name }
  not_emailed_users.sort! { |a, b| a.last_name <=> b.last_name }

  output
end
