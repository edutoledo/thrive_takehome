# Thrive take home challenge

## Running example and tests

To run the challenge code, as requested, simply call:

```
ruby challenge.rb
```

at the root folder of the project.

If you are not using the targeted Ruby version (and you use rbenv), then run rbenv to get the proper version. If you run `bundle install` and then `bundle exec rubocop .` you will get no rubocop warnings (assuming rubocop installed with no problems).

You can run the specs by running `bundle install` (if you haven't already) and then `bundle exec rspec spec/`, they are all passing.

## Explanation

- The ruby version I used (3.1.2) is just the one that came by default on the WSL (Windows Subsystem for Linux) Debian instance. Some of the syntax is specific to Ruby 3.1 (or greater), so you'll need to have that installed, or use rbenv or your ruby version manager of choice to get it.
- Most work was done in a TDD fashion, using Red, Green, Refactor. Eventually I wrote the 2 class to refactor better. Then I covered them with a test suite.
- All work done can be seen in the commit history.
- There are no specs covering the output piece since that is more akin to manual QA, I did manual testing, visual comparison and diffs.
- Output in `main` branch is not identical to example output, but on branch called `identical` it is.
- A different solution is in branch `models`, using a "model-first" approach with User and Company classes containing more of the logic. Personally I prefer the InputParser and CompaniesUsersPrinter lib classes approach. In a real-world situation the models would (most likely) be ActiveRecord models backed by a DB, they should have minimal business logic aside from validation and simple things (in my opinion). Most of the business logic should be in services/library used by whatever API (or controller and views) the RoR server implements (e.g. queries and mutations for GraphQL would call these services/library class/methods).
- Typically I would not write so many comments on the code. The code (at least in Ruby, but it's a good ideal to strive for) should "speak for itself", variable and method names should explain what they store and what they do. Code in methods should make sense as you read it. I added lots of comments to convey my thinking and reasons for doing things the way I did.
- It should go without saying that in a real-life situation I would not be commiting to the `main`/`master` branch directly without a PR and approval(s). This being an exercise I took the liberty of doing that.
- There are no debugger breakpoints (`binding.pry`) anywhere in the code, but I left pry in the Gemfile anyways.

## RSpec usage

- All specs must be run from the project root folder, otherwise all the requires will not resolve to the correct file.
- The specs may not look like your typical RSpec file. In my last work the team decided the use of let statements and subject actually leads to a lot of confusion.
- Each unit test ('it' block) is completely self contained, all variable definitions are right there and exactly what code is running is very clear.
- It does lead to more verbose specs and a lot of duplication accross tests. However, the goal of a unit test is not conciseness, it is clarity, it should be a contract describing how a part of your code should behave.
- Another break from convention that seems to exist only for the sake of convention is the usage (or lack thereof) of context blocks. The 'it' blocks have more descriptive texts instead of nesting them into more context blocks.
- I have also used many expects within each 'it', I see nothing wrong with that as well.

## Caveats

- You will see 2 contributors here. That is because I used both my emails. My live account email was used for an existing GitHub account, but I have not used that account in years. For consistency I will use only my gmail for most of the commits.
