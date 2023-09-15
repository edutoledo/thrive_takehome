# frozen_string_literal: true

require 'json'
require './lib/input_parser'

# rubocop:disable Metrics/BlockLength
describe InputParser do
  # Since the whole module only has one public method, I'll dispense with creating yet another
  # level of describe
  it 'parses a single active user properly' do
    users_in = [
      {
        id: 1,
        first_name: 'Tanya',
        last_name: 'Nichols',
        email: 'tanya.nichols@test.com',
        company_id: 2,
        email_status: true,
        active_status: true,
        tokens: 23
      }
    ]

    allow(File).to receive(:read).with('USERS_FILE').and_return(users_in.to_json)
    allow(File).to receive(:read).with('COMPANIES_FILE').and_return('[]')

    users, = InputParser.read_and_parse_users_and_companies('USERS_FILE', 'COMPANIES_FILE')

    expect(users).not_to be_nil
    expect(users.size).to eq(1)
    expect(users.first).to have_attributes(
      first_name: 'Tanya',
      last_name: 'Nichols',
      email: 'tanya.nichols@test.com',
      company_id: 2,
      email_status: true,
      tokens: 23
    )
  end

  it 'removes inactive user' do
    users_in = [
      {
        id: 1,
        first_name: 'Tanya',
        last_name: 'Nichols',
        email: 'tanya.nichols@test.com',
        company_id: 2,
        email_status: true,
        active_status: true,
        tokens: 23
      },
      {
        id: 11,
        first_name: 'Alexander',
        last_name: 'Gardner',
        email: 'alexander.gardner@demo.com',
        company_id: 4,
        email_status: false,
        active_status: false,
        tokens: 40
      }
    ]

    allow(File).to receive(:read).with('USERS_FILE').and_return(users_in.to_json)
    allow(File).to receive(:read).with('COMPANIES_FILE').and_return('[]')

    users, = InputParser.read_and_parse_users_and_companies('USERS_FILE', 'COMPANIES_FILE')

    expect(users).not_to be_nil
    expect(users.size).to eq(1)
    expect(users.first).to have_attributes(
      first_name: 'Tanya',
      last_name: 'Nichols',
      email: 'tanya.nichols@test.com',
      company_id: 2,
      email_status: true,
      tokens: 23
    )
  end

  it 'parses and sorts (by last name) many active users properly' do
    users_in = [
      {
        id: 1,
        first_name: 'Tanya',
        last_name: 'Nichols',
        email: 'tanya.nichols@test.com',
        company_id: 2,
        email_status: true,
        active_status: true,
        tokens: 23
      },
      {
        id: 11,
        first_name: 'Alexander',
        last_name: 'Gardner',
        email: 'alexander.gardner@demo.com',
        company_id: 4,
        email_status: false,
        active_status: true,
        tokens: 40
      }
    ]

    allow(File).to receive(:read).with('USERS_FILE').and_return(users_in.to_json)
    allow(File).to receive(:read).with('COMPANIES_FILE').and_return('[]')

    users, = InputParser.read_and_parse_users_and_companies('USERS_FILE', 'COMPANIES_FILE')

    expect(users).not_to be_nil
    expect(users.size).to eq(2)
    expect(users.first).to have_attributes(
      first_name: 'Alexander',
      last_name: 'Gardner',
      email: 'alexander.gardner@demo.com',
      company_id: 4,
      email_status: false,
      tokens: 40
    )
    expect(users.last).to have_attributes(
      first_name: 'Tanya',
      last_name: 'Nichols',
      email: 'tanya.nichols@test.com',
      company_id: 2,
      email_status: true,
      tokens: 23
    )
  end
end

describe '#parse_and_sort_companies' do
  it 'parses a single company properly' do
    companies_in = [
      {
        id: 42,
        name: 'Ramjac Corporation',
        top_up: 9001,
        email_status: false
      }
    ]

    allow(File).to receive(:read).with('USERS_FILE').and_return('[]')
    allow(File).to receive(:read).with('COMPANIES_FILE').and_return(companies_in.to_json)

    _, companies = InputParser.read_and_parse_users_and_companies('USERS_FILE', 'COMPANIES_FILE')

    expect(companies).not_to be_nil
    expect(companies.size).to eq(1)
    expect(companies.first).to have_attributes(
      id: 42,
      name: 'Ramjac Corporation',
      top_up: 9001,
      email_status: false
    )
  end

  it 'parses and sorts (by id) many companies properly' do
    companies_in = [
      {
        id: 1337,
        name: 'Dynamic',
        top_up: 300,
        email_status: true
      },
      {
        id: 42,
        name: 'Ramjac Corporation',
        top_up: 9001,
        email_status: false
      }
    ]

    allow(File).to receive(:read).with('USERS_FILE').and_return('[]')
    allow(File).to receive(:read).with('COMPANIES_FILE').and_return(companies_in.to_json)

    _, companies = InputParser.read_and_parse_users_and_companies('USERS_FILE', 'COMPANIES_FILE')

    expect(companies).not_to be_nil
    expect(companies.size).to eq(2)
    expect(companies.first).to have_attributes(
      id: 42,
      name: 'Ramjac Corporation',
      top_up: 9001,
      email_status: false
    )
    expect(companies.last).to have_attributes(
      id: 1337,
      name: 'Dynamic',
      top_up: 300,
      email_status: true
    )
  end
end
# rubocop:enable Metrics/BlockLength
