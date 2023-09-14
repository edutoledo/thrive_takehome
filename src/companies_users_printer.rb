# frozen_string_literal: true

# Takes unorganized array of users and companies, organizes them as required and prints to file
class CompaniesUsersPrinter
  # Mainly here so I don't have to reference them internally as an instance variable and so specs
  # can check values
  attr_reader :users, :companies, :company_users

  def initialize(users:, companies:)
    raise 'Users cannot be nil' if users.nil?
    raise 'Companies cannot be nil' if companies.nil?

    @users = users
    @companies = companies

    sort_users
    sort_companies

    group_users_by_company_and_email_status
  end

  private

  def sort_users
    users.sort! { |a, b| a.last_name <=> b.last_name }
  end

  def sort_companies
    companies.sort! { |a, b| a.id <=> b.id }
  end

  def group_users_by_company_and_email_status; end
end
