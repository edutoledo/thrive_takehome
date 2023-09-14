# frozen_string_literal: true

require 'json'
require './lib/companies_users_printer'

User = Struct.new(
  :first_name,
  :last_name,
  :email,
  :company_id,
  :email_status,
  :tokens
)

Company = Struct.new(:id, :name, :top_up, :email_status)

def parse_filter_and_sort_users(users)
  users.map! do |user|
    next unless user['active_status']

    User.new(
      user['first_name'], user['last_name'], user['email'],
      user['company_id'], user['email_status'], user['tokens']
    )
  end

  users.compact.sort { |a, b| a.last_name <=> b.last_name }
end

def parse_and_sort_companies(companies)
  companies.map! do |company|
    Company.new(company['id'], company['name'], company['top_up'], company['email_status'])
  end

  companies.sort { |a, b| a.id <=> b.id }
end

# No specs written for this method since it does simple things, reading a file, parsing JSON,
# and calling 2 other methods that are already covered by specs.
def read_and_parse_users_and_companies(users_filename, companies_filename)
  [
    parse_filter_and_sort_users(JSON.parse(File.read(users_filename))),
    parse_and_sort_companies(JSON.parse(File.read(companies_filename)))
  ]
  # TODO: Both file read and json parse can raise errors, handle those
end

def print_out_companies_users
  users, companies = read_and_parse_users_and_companies('input/users.json', 'input/companies.json')
  printer = CompaniesUsersPrinter.new(users, companies)
  printer.print_to_file('output.txt')
end

print_out_companies_users
