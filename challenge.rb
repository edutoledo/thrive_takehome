# frozen_string_literal: true

require 'json'
require './lib/companies_users_printer'
require './lib/input_parser'

# This is here more for the sake of convention
module Challenge
  # include InputParser

  def print_out_companies_users
    users, companies = InputParser.read_and_parse_users_and_companies('input/users.json',
                                                                      'input/companies.json')
    printer = CompaniesUsersPrinter.new(users, companies)
    printer.print_to_file('output.txt')
  end

  module_function :print_out_companies_users
end

Challenge.print_out_companies_users
