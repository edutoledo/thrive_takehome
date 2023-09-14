# frozen_string_literal: true

# Takes unorganized array of users and companies, organizes them as required and prints to file
class CompaniesUsersPrinter
  # Mainly here so I don't have to reference them internally as an instance variable and so specs
  # can check values
  attr_reader :users, :companies, :grouped_company_users

  # users and companies are expected to be sorted, and inactive users filtered out
  def initialize(users, companies)
    raise 'Users cannot be nil' if users.nil?
    raise 'Companies cannot be nil' if companies.nil?

    @users = users
    @companies = companies

    group_users_by_company_and_email_status
  end

  def print_to_file(filename)
    File.write(filename, print_string)
  rescue StandardError => e
    puts "Error writing to file #{filename} in CompaniesUsersPrinter #print_to_file"
    puts e
  end

  private

  def group_users_by_company_and_email_status
    @grouped_company_users = []

    companies.each do |company|
      # Did not know about this, new for Ruby 3.1. RuboCop showing me all the neat new features.
      # Shorthand notation for key with the same name as the variable, similar to JS, nice.
      grouped_data = { company: }
      grouped_by_email = group_users_by_email_status(company)

      # We don't print out companies with no valid users, so no need to
      # store them in the organized data
      next if grouped_by_email[:emailed_users].nil? && grouped_by_email[:not_emailed_users].nil?

      # In case one of them is nil, replace with empty array,
      # otherwise running .size on it will error
      grouped_by_email[:emailed_users] ||= []
      grouped_by_email[:not_emailed_users] ||= []

      grouped_company_users << grouped_data.merge(grouped_by_email)
    end
  end

  def group_users_by_email_status(company)
    # This is the most compact/concise way I could find of doing this. It's not really the most
    # clear, the simple each version (option 1 below) would be better for that.
    #
    # Other ways of doing this:
    #   1) Running just an each with a next unless user.company_id == company.id at the top, then a
    #      simple if/else to store them in different arrays, return the arrays.
    #   2) Using map! and compact! to make the users array smaller each time, probably makes no
    #      difference for performance. Could actually make it worse with the increased complexity
    #      of running compact in place.
    #   3) Run a filter (to filter by company id) then an each.
    users.filter { |u| u.company_id == company.id }.group_by do |user|
      company.email_status && user.email_status ? :emailed_users : :not_emailed_users
    end
  end

  def print_users(users, top_up)
    # Gotta put a conditional newline here
    output = users.size.positive? ? "\n" : ''
    output + users.map do |user|
      # Looks nicer without the indentation, things line up more like they'll look in the file,
      # sometimes conventions are meant to be broken.
      # rubocop:disable Layout/LineEndStringConcatenationIndentation
      "\t\t#{user.last_name}, #{user.first_name}, #{user.email}" \
      "\n\t\t\tPrevious Token Balance, #{user.tokens}" \
      "\n\t\t\tNew Token Balance #{user.tokens + top_up}"
      # rubocop:enable Layout/LineEndStringConcatenationIndentation
    end.join("\n")
  end

  # 1 line more than the 10 allowed by the method length
  def print_string # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    # rubocop:disable Style/StringConcatenation
    grouped_company_users.map do |company_users|
      company = company_users[:company]
      user_count = company_users[:emailed_users].size + company_users[:not_emailed_users].size

      # Looks nicer without the indentation, things line up more like they'll look in the file,
      # sometimes conventions are meant to be broken.
      # rubocop:disable Layout/MultilineOperationIndentation
      "\n\tCompany Id: #{company.id}" \
      "\n\tCompany Name: #{company.name}" \
      "\n\tUsers Emailed:" +
      print_users(company_users[:emailed_users], company.top_up) +
      "\n\tUsers Not Emailed:" +
      print_users(company_users[:not_emailed_users], company.top_up) +
      "\n\t\tTotal amount of top ups for #{company.name}: #{user_count * company.top_up}"
      # rubocop:enable Style/StringConcatenation, Layout/MultilineOperationIndentation
    end.join("\n") + "\n"
  end
end
