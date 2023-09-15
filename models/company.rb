# frozen_string_literal: true

class Company
  attr_reader :id

  # id is not necessary, and by filtering from the source based on active_status we don't need to
  # keep that either
  def initialize(id, name, top_up, email_status)
    @id = id
    @name = name
    @top_up = top_up
    @email_status = email_status
  end

  # users array must already be filtered by company_id and sorted
  def add_users(users)
    @not_emailed_users ||= []
    @emailed_users ||= []
    @total_top_up ||= 0

    users.each do |user|
      user.top_up(@top_up)
      @total_top_up += @top_up
      if @email_status && user.email_status
        @emailed_users << user
      else
        @not_emailed_users << user
      end
    end
  end

  def print
    raise 'Company is invalid' unless valid?

    # rubocop:disable Layout/LineEndStringConcatenationIndentation
    "\n\tCompany Id: #{@id}" \
    "\n\tCompany Name: #{@name}" \
    "\n\tUsers Emailed:#{print_emailed_users}" \
    "\n\tUsers Not Emailed:#{print_not_emailed_users}" \
    "\n\t\tTotal amount of top ups for #{@name}: #{@total_top_up}"
    # rubocop:enable Layout/LineEndStringConcatenationIndentation
  end

  # This is some basic error handling, other fields can be nil
  def valid?
    !@id.nil? && @top_up.is_a?(Integer)
  end

  private

  def print_users(users)
    (users.size.positive? ? "\n" : '') + users.map(&:print).join("\n")
  end

  def print_emailed_users
    raise 'No users added to company' if @emailed_users.nil?

    print_users(@emailed_users)
  end

  def print_not_emailed_users
    raise 'No users added to company' if @not_emailed_users.nil?

    print_users(@not_emailed_users)
  end
end
