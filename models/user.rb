# frozen_string_literal: true

class User
  attr_reader :last_name, :company_id, :email_status

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
