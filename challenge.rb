# frozen_string_literal: true

require './lib/input_parser'

# This is here more for the sake of convention
module Challenge
  def print_out_companies_users
    users, companies = InputParser.read_and_parse_users_and_companies(
      'input/users.json',
      'input/companies.json'
    )

    companies.each do |company|
      company.add_users(users.filter { |user| user.company_id == company.id })
    end

    File.write('log.txt', companies.map(&:print))
  end

  module_function :print_out_companies_users
end

Challenge.print_out_companies_users
