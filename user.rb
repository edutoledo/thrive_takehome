# frozen_string_literal: true

class User
  attr_reader :tokens, :first_name, :last_name, :email, :previous_tokens

  # id is not necessary, and by filtering from the source based on active_status we don't need to
  # keep that either
  def initialize(first_name, last_name, email, company_id, email_status, tokens)
    @first_name = first_name
    @last_name = last_name
    @email = email
    @company_id = company_id
    @user_email_status = email_status
    @tokens = tokens
  end

  def top_up(amount)
    return unless valid?

    @previous_tokens = @tokens
    @tokens += amount
  end

  def compute_email_status(company_email_status)
    # Compute it only once
    return if @has_computed_email_status

    # Since @email_status can be nil (and still valid) in case company_email_status is truthey, but
    # @user_email_status is nil, we need some other way of knowing this method has been run.
    # Considering nil to be valid, since it's falsey in Ruby, so a missing or explcitly null value
    # in the input will just default to false.
    @has_computed_email_status = true
    @email_status = company_email_status && @user_email_status
  end

  def should_email?
    raise 'The company email status was not provided.' unless @has_computed_email_status

    # For convention, a predicate method ends in ? and always returns a boolean (unless it raises),
    # so running !! on it in case it's some other value that can be truthy or falsey.
    !!@email_status
  end

  def print
    raise 'User is invalid' unless valid?
    raise 'User has no previous_tokens, did you forget to top up the user?' unless @previous_tokens

    # rubocop:disable Layout/LineEndStringConcatenationIndentation
    "\t\t#{@last_name}, #{@first_name}, #{@email}" \
    "\n\t\t\tPrevious Token Balance: #{@previous_tokens}" \
    "\n\t\t\tNew Token Balance: #{@tokens}"
    # rubocop:enable Layout/LineEndStringConcatenationIndentation
  end

  # This is some basic error handling, other fields can be nil
  def valid?
    @tokens.is_a?(Integer)
  end
end
