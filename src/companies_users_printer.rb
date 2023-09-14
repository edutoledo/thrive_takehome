# frozen_string_literal: true

# Takes unorganized array of users and companies, organizes them as required and prints to file
class CompaniesUsersPrinter
  # Mainly here so I don't have to reference them internally as an instance variable and so specs
  # can check values
  attr_reader :users, :companies, :grouped_company_users

  def initialize(users:, companies:)
    raise 'Users cannot be nil' if users.nil?
    raise 'Companies cannot be nil' if companies.nil?

    @users = users
    @companies = companies

    # Filter out inactive users, and sort both arrays as required
    user.filter!(&:active_status).sort! { |a, b| a.last_name <=> b.last_name }
    companies.sort! { |a, b| a.id <=> b.id }
    group_users_by_company_and_email_status
    # TODO: write this next one
    # top_up_users
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

      grouped_company_users << grouped_data.merge(grouped_by_email)
    end

    # Don't really need to return it since it's stored in an instance variable, but... why not?
    grouped_company_users
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
end
