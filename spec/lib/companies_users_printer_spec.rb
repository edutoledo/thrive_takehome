# frozen_string_literal: true

require './lib/input_parser'
require './lib/companies_users_printer'

# Again we are only testing one aspect of CompaniesUsersPrinter, so no need for a
# describe within a describe
# rubocop:disable Metrics/BlockLength
describe CompaniesUsersPrinter do
  it 'groups users by company, excluding users that have no company' do
    users = [
      User.new('Tanya', 'Aaa', 'tanya.nichols@test.com', 2, true, 23),
      User.new('First', 'Bbb', 'second@email.com', 1, true, 1)
    ]
    companies = [
      Company.new(2, 'Ramjac Corp', 300, false)
    ]

    result = CompaniesUsersPrinter.new(users, companies).grouped_company_users

    expect(result.size).to eq(1)
    expect(result.first[:company]).to eq(companies.first)
    expect(result.first[:emailed_users].size).to eq(0)
    expect(result.first[:not_emailed_users].size).to eq(1)
    expect(result.first[:not_emailed_users].first).to eq(users.first)
  end

  it 'groups users by emailed status, taking into account company email status' do
    users = [
      User.new('Tanya', 'Aaa', 'tanya.nichols@test.com', 2, true, 23),
      User.new('Other', 'Aaz', 'email@test.com', 2, false, 5),
      User.new('First', 'Bbb', 'second@email.com', 1, true, 6),
      User.new('Yeti', 'Bbz', 'yeti@email.com', 1, false, 1)
    ]
    companies = [
      Company.new(1, 'A&B GIANT', 150, false),
      Company.new(2, 'Ramjac Corp', 300, true)
    ]

    result = CompaniesUsersPrinter.new(users, companies).grouped_company_users

    expect(result.size).to eq(2)

    expect(result.first[:company]).to eq(companies.first)
    expect(result.first[:emailed_users].size).to eq(0)
    expect(result.first[:not_emailed_users].size).to eq(2)
    expect(result.first[:not_emailed_users].first).to eq(users[2])
    expect(result.first[:not_emailed_users].last).to eq(users.last)

    expect(result.last[:company]).to eq(companies.last)
    expect(result.last[:emailed_users].size).to eq(1)
    expect(result.last[:emailed_users].first).to eq(users.first)
    expect(result.last[:not_emailed_users].size).to eq(1)
    expect(result.last[:not_emailed_users].first).to eq(users[1])
  end

  it 'groups users by company, excluding companies that have no user' do
    users = [
      User.new('Tanya', 'Aaa', 'tanya.nichols@test.com', 2, true, 23),
      User.new('First', 'Bbb', 'second@email.com', 1, true, 1)
    ]
    companies = [
      Company.new(2, 'Ramjac Corp', 300, false),
      Company.new(20, 'Ramjac Corp Competitor', 3000, false)
    ]

    result = CompaniesUsersPrinter.new(users, companies).grouped_company_users

    expect(result.size).to eq(1)
    expect(result.first[:company]).to eq(companies.first)
    expect(result.first[:emailed_users].size).to eq(0)
    expect(result.first[:not_emailed_users].size).to eq(1)
    expect(result.first[:not_emailed_users].first).to eq(users.first)
  end
end
# rubocop:enable Metrics/BlockLength
