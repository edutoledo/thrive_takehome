# frozen_string_literal: true

require './challenge'

# rubocop:disable Metrics/BlockLength
describe 'challenge' do
  describe '#parse_users' do
    it 'parses a single user properly' do
      users = [
        {
          'id' => 1,
          'first_name' => 'Tanya',
          'last_name' => 'Nichols',
          'email' => 'tanya.nichols@test.com',
          'company_id' => 2,
          'email_status' => true,
          'active_status' => false,
          'tokens' => 23
        }
      ]

      result = parse_users(users)

      expect(result).not_to be_nil
      expect(result.size).to eq(1)
      expect(result.first).to have_attributes(
        id: 1,
        first_name: 'Tanya',
        last_name: 'Nichols',
        email: 'tanya.nichols@test.com',
        company_id: 2,
        email_status: true,
        active_status: false,
        tokens: 23
      )
    end

    it 'parses many users properly' do
      users = [
        {
          'id' => 1,
          'first_name' => 'Tanya',
          'last_name' => 'Nichols',
          'email' => 'tanya.nichols@test.com',
          'company_id' => 2,
          'email_status' => true,
          'active_status' => false,
          'tokens' => 23
        },
        {
          'id' => 11,
          'first_name' => 'Alexander',
          'last_name' => 'Gardner',
          'email' => 'alexander.gardner@demo.com',
          'company_id' => 4,
          'email_status' => false,
          'active_status' => true,
          'tokens' => 40
        }
      ]

      result = parse_users(users)

      expect(result).not_to be_nil
      expect(result.size).to eq(2)
      expect(result.first).to have_attributes(
        id: 1,
        first_name: 'Tanya',
        last_name: 'Nichols',
        email: 'tanya.nichols@test.com',
        company_id: 2,
        email_status: true,
        active_status: false,
        tokens: 23
      )
      expect(result.last).to have_attributes(
        id: 11,
        first_name: 'Alexander',
        last_name: 'Gardner',
        email: 'alexander.gardner@demo.com',
        company_id: 4,
        email_status: false,
        active_status: true,
        tokens: 40
      )
    end
  end
end
# rubocop:enable Metrics/BlockLength
