# frozen_string_literal: true

require 'json'
require './models/user'
require './models/company'

module InputParser
  # This class is keeping methods private
  class InputParser
    def read_and_parse_users_and_companies(users_filename, companies_filename)
      [
        parse_filter_and_sort_users(JSON.parse(File.read(users_filename))),
        parse_and_sort_companies(JSON.parse(File.read(companies_filename)))
      ]
    rescue StandardError => e
      puts "Error reading or parsings files #{users_filename}, #{companies_filename} in " \
           'InputParser#read_and_parse_users_and_companies'
      puts e
    end

    private

    def parse_filter_and_sort_users(users)
      users.map! do |user|
        next unless user['active_status']

        user_model = User.new(
          user['first_name'], user['last_name'], user['email'],
          user['company_id'], user['email_status'], user['tokens']
        )
        next unless user_model.valid?

        user_model
      end

      users.compact.sort { |a, b| a.last_name <=> b.last_name }
    end

    def parse_and_sort_companies(companies)
      companies.map! do |company|
        company_model = Company.new(
          company['id'], company['name'], company['top_up'], company['email_status']
        )
        next unless company_model.valid?

        company_model
      end

      companies.compact.sort { |a, b| a.id <=> b.id }
    end
  end

  def read_and_parse_users_and_companies(users_filename, companies_filename)
    InputParser.new.read_and_parse_users_and_companies(users_filename, companies_filename)
  end

  module_function :read_and_parse_users_and_companies
end
