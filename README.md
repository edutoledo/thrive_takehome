# Thrive take home challenge

## Explanation

- The ruby version I used (3.1.2) is just the one that came by default on the WSL (Windows Subsystem for Linux) Debian instance. I did not double check this, but the code should be simple enough to work on 2.X Ruby (or possible even 3.2).
- All work was done in a TDD fashion; write a unit test, see it fail. Write the minimum amount of code to see it pass. Refactor. (Red Green Refactor)
- I left all refactoring as the very last thing, once the full test suite was there. The initial "final" solution just has all the code running in a single file with some methods, no real classes, just Structs.
- All work done can be seen in the commit history.
- All error handling logic was made at the end.

## RSpec usage

- The specs may not look like your typical RSpec file. In my last work the team decided the use of let statements and subject actually leads to a lot of confusion.
- Each unit test ('it' block) is completely self contained, all variable definitions are right there and exactly what code is running is very clear.
- It does lead to more verbose specs and a lot of duplication accross tests. However, the goal of a unit test is not conciseness, it is clarity, it should be a contract describing how a part of your code should behave.
- Another break from convention that seems to exist only for the sake of convention is the usage (or lack thereof) of context blocks. The 'it' blocks have more descriptive texts instead of nesting them into more context blocks.
- I have also used many expects within each 'it', I see nothing wrong with that as well.

## Caveats

- You will see 2 contributors here. That is because I used both my emails. My live account email was used for an existing GitHub account, but I have not used that account in years. For consistency I will use only my gmail for most of the commits.
