# frozen_string_literal: true

require 'json'

# No need to have a whole class for User. The challenge does state:
#   Any user that belongs to a company in the companies file and is active
#   needs to get a token top up of the specified amount in the companies top up
#   field.
# But since the true purpose is to print out that data to a file, it adds unnecessary complexity
# to have a whole class just to satisfy that something was "topped up". This won't be stored
# anywhwere except the output text file, so for all intents and purposes the final "user" was
# topped up.
User = Struct.new(
  :first_name,
  :last_name,
  :email,
  :company_id,
  :email_status,
  :tokens
)
# Same thing for company, a whole class is not needed.
Company = Struct.new(:id, :name, :top_up, :email_status)

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

    def error_handle_user(user)
      # Handle wrong input. The ones that matter are company_id and tokens, the rest will look
      # weird if they're nil, but they won't lead to errors down the line. Raising is another
      # option for doing this, but it would halt and exit.
      return "User with id: #{user['id']} has no tokens\n" if user['tokens'].nil?
      return "User with id: #{user['id']} has no company_id\n" if user['company_id'].nil?
      return if user['tokens'].is_a?(Integer)

      "User with id: #{user['id']} has invalid type for tokens\n"
    end

    def parse_filter_and_sort_users(users)
      users.map! do |user|
        next unless user['active_status']

        err = error_handle_user(user)
        unless err.nil?
          # Just writing it to stdout
          puts err
          next
        end

        User.new(
          user['first_name'], user['last_name'], user['email'],
          user['company_id'], user['email_status'], user['tokens']
        )
      end

      users.compact.sort { |a, b| a.last_name <=> b.last_name }
    end

    def error_handle_company(company)
      # Handle wrong input. The ones that matter are id and top_up, the rest will look
      # weird if they're nil, but they won't lead to errors down the line. Raising is another
      # option for doing this, but it would halt and exit.
      if company['id'].nil?
        return "Company missing an id, maybe it has a name: #{company['name']}\n"
      end
      return "Company with id: #{company['id']} has no top_up\n" if company['top_up'].nil?
      return if company['top_up'].is_a?(Integer)

      "Company with id: #{company['id']} has invalid type for top_up\n"
    end

    def parse_and_sort_companies(companies)
      companies.map! do |company|
        err = error_handle_company(company)
        unless err.nil?
          # Just writing it to stdout
          puts err
          next
        end

        Company.new(company['id'], company['name'], company['top_up'], company['email_status'])
      end

      companies.compact.sort { |a, b| a.id <=> b.id }
    end
  end

  # No specs written for this method since it does simple things, reading a file, parsing JSON,
  # and calling 2 other methods that are already covered by specs.
  def read_and_parse_users_and_companies(users_filename, companies_filename)
    InputParser.new.read_and_parse_users_and_companies(users_filename, companies_filename)
  end

  module_function :read_and_parse_users_and_companies
end
