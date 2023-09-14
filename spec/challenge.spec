# frozen_string_literal: true

require './challenge'

# rubocop:disable Metrics/BlockLength
describe 'challenge' do
  describe '#parse_and_filter_users' do
    it 'parses a single active user properly' do
      users = [
        {
          'id' => 1,
          'first_name' => 'Tanya',
          'last_name' => 'Nichols',
          'email' => 'tanya.nichols@test.com',
          'company_id' => 2,
          'email_status' => true,
          'active_status' => true,
          'tokens' => 23
        }
      ]

      result = parse_and_filter_users(users)

      expect(result).not_to be_nil
      expect(result.size).to eq(1)
      expect(result.first).to have_attributes(
        first_name: 'Tanya',
        last_name: 'Nichols',
        email: 'tanya.nichols@test.com',
        company_id: 2,
        email_status: true,
        tokens: 23
      )
    end

    it 'removes inactive user' do
      users = [
        {
          'id' => 1,
          'first_name' => 'Tanya',
          'last_name' => 'Nichols',
          'email' => 'tanya.nichols@test.com',
          'company_id' => 2,
          'email_status' => true,
          'active_status' => true,
          'tokens' => 23
        },
        {
          'id' => 11,
          'first_name' => 'Alexander',
          'last_name' => 'Gardner',
          'email' => 'alexander.gardner@demo.com',
          'company_id' => 4,
          'email_status' => false,
          'active_status' => false,
          'tokens' => 40
        }
      ]

      result = parse_and_filter_users(users)

      expect(result).not_to be_nil
      expect(result.size).to eq(1)
      expect(result.first).to have_attributes(
        first_name: 'Tanya',
        last_name: 'Nichols',
        email: 'tanya.nichols@test.com',
        company_id: 2,
        email_status: true,
        tokens: 23
      )
    end

    it 'parses many active users properly' do
      users = [
        {
          'id' => 1,
          'first_name' => 'Tanya',
          'last_name' => 'Nichols',
          'email' => 'tanya.nichols@test.com',
          'company_id' => 2,
          'email_status' => true,
          'active_status' => true,
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

      result = parse_and_filter_users(users)

      expect(result).not_to be_nil
      expect(result.size).to eq(2)
      expect(result.first).to have_attributes(
        first_name: 'Tanya',
        last_name: 'Nichols',
        email: 'tanya.nichols@test.com',
        company_id: 2,
        email_status: true,
        tokens: 23
      )
      expect(result.last).to have_attributes(
        first_name: 'Alexander',
        last_name: 'Gardner',
        email: 'alexander.gardner@demo.com',
        company_id: 4,
        email_status: false,
        tokens: 40
      )
    end
  end

  describe '#parse_companies' do
    it 'parses a single company properly' do
      companies = [
        {
          'id' => 42,
          'name' => 'Ramjac Corporation',
          'top_up' => 9001,
          'email_status' => false
        }
      ]

      result = parse_companies(companies)

      expect(result).not_to be_nil
      expect(result.size).to eq(1)
      expect(result.first).to have_attributes(
        id: 42,
        name: 'Ramjac Corporation',
        top_up: 9001,
        email_status: false
      )
    end

    it 'parses many companies properly' do
      companies = [
        {
          'id' => 42,
          'name' => 'Ramjac Corporation',
          'top_up' => 9001,
          'email_status' => false
        },
        {
          'id' => 1337,
          'name' => 'Dynamic',
          'top_up' => 300,
          'email_status' => true
        }
      ]

      result = parse_companies(companies)

      expect(result).not_to be_nil
      expect(result.size).to eq(2)
      expect(result.first).to have_attributes(
        id: 42,
        name: 'Ramjac Corporation',
        top_up: 9001,
        email_status: false
      )
      expect(result.last).to have_attributes(
        id: 1337,
        name: 'Dynamic',
        top_up: 300,
        email_status: true
      )
    end
  end
end
# rubocop:enable Metrics/BlockLength
