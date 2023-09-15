# frozen_string_literal: true

require './lib/input_parser'

# This is here more for the sake of convention
module Challenge
  def print_out_companies_users
    users, companies = InputParser.read_and_parse_users_and_companies(
      'input/users.json',
      'input/companies.json'
    )

    companies.map! do |company|
      company_users = users.filter { |user| user.company_id == company.id }
      next if company_users.empty?

      company.add_users(company_users)
      company
    end.compact!

    File.write('output.txt', "#{companies.map(&:print).join("\n")}\n\n")
  end

  module_function :print_out_companies_users
end

Challenge.print_out_companies_users
