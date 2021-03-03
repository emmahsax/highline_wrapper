# Highline Wrapper [![Main](https://github.com/emmahsax/highline_wrapper/actions/workflows/main.yml/badge.svg)](https://github.com/emmahsax/highline_wrapper/actions/workflows/main.yml)

A little wrapper to help ask some easy questions via the command-line with Highline. The types of questions this wrapper supports is:

* Open-ended question
* Yes/No question
* Multiple choice question where the user is allowed to select one answer
* Multiple choice "checkbox" question where the user is allowed to select multiple answers

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'highline_wrapper'
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install highline_wrapper
```

## Usage

Once this gem is installed, you can then initiate a new `HighlineWrapper` object:

```ruby
HighlineWrapper.new
```

Then, add this to the top of your file (or to your gem):

```ruby
require 'highline_wrapper'
```

Then, you can call its questions to receive answers. There's several configuration options for each type of question. Look below for the different options for each type of question, and what they each return.

### Open-ended questions

Question configuration options:
* `secret`: defaults to `false`
* `required`: defaults to `false`

<details><summary>Examples</summary>

```ruby
> HighlineWrapper.new.ask('What is your favorite number?')
What is your favorite number?
four
=> "four"

> HighlineWrapper.new.ask('What is your favorite number?', {required: true})
What is your favorite number?

This question is required.

What is your favorite number?

This question is required.

What is your favorite number?
2
=> "2"

> HighlineWrapper.new.ask('What is your favorite color?')
What is your favorite color?

=> ""

> HighlineWrapper.new.ask('Please type your private token:', {secret: true})
Please type your private token?
****************
=> "MY-PRIVATE-TOKEN"

> HighlineWrapper.new.ask('What is your private token?', {secret: true, required: true})
What is your private token?

This question is required.

What is your private token?

This question is required.

What is your private token?

This question is required.

What is your private token?
****************
=> "MY-PRIVATE-TOKEN"
```

</details>

### Yes/No questions

Question configuration options:
* `default`: defaults to `true` (aka 'yes')
* `required`: defaults to `false`

<details><summary>Examples</summary>

```ruby
> HighlineWrapper.new.ask_yes_no('Do you like Ruby?')
Do you like Ruby?
no
=> false

> HighlineWrapper.new.ask_yes_no('Do you like Ruby?')
Do you like Ruby?
yes
=> true

> HighlineWrapper.new.ask_yes_no('Do you like Ruby?', {default: true})
Do you like Ruby?

=> true

> HighlineWrapper.new.ask_yes_no('Do you like Ruby?', {required: true})
Do you like Ruby?

This question is required.

Do you like Ruby?
No
=> false
```

</details>

### Multiple choice question

Question configuration options:
* `with_index`: defaults to `false` (particularly handy when there may be duplicate-named but different items in the list—think Sally with ID 45 and Sally with ID 72)
* `default`: defaults to `nil`
* `required`: defaults to `false`

Notes:
* If `required` is `true`, the question will repeat until the user answers the question
* If `required` is `true`, then the `default` value will be ignored (defaults to `nil`, but could be set to whatever and the code won't care... the question is required)
* If `default` is `nil` and `required` is `false`, and the user skips the question, the answer will be `nil`
* If `with_index` is `true`, a hash will be returned with the choice AND the index of the selection in the original `choices` array
  * e.g. `{ value: 'c', index: 2 }`
* If `with_index` is `false`, then a hash of one item will be returned
  * e.g. `{ value: 'c' }`

<details><summary>Examples</summary>

```ruby
> HighlineWrapper.new.ask_multiple_choice('What is your favorite number of these?', ['one', 'two', 'three'])
What is your favorite number of these?
1. one
2. two
3. three
2
=> {:value=>"two"}

> HighlineWrapper.new.ask_multiple_choice('What is your favorite number of these?', ['one', 'two', 'three'], {with_index: true})
What is your favorite number of these?
1. one
2. two
3. three
2
=> {:value=>"two", :index=>1}

> HighlineWrapper.new.ask_multiple_choice('What is your favorite number of these?', ['one', 'two', 'three'], {with_index: true, default: 'one'})
What is your favorite number of these?
1. one
2. two
3. three

=> {:value=>"one", :index=>0}

> HighlineWrapper.new.ask_multiple_choice('What is your favorite number of these?', ['one', '
two', 'three'], {default: 'three', required: true})
What is your favorite number of these?
1. one
2. two
3. three

This question is required.

What is your favorite number of these?
1. one
2. two
3. three

This question is required.

What is your favorite number of these?
1. one
2. two
3. three
2
=> {:value=>"two"}

> HighlineWrapper.new.ask_multiple_choice('What is your favorite number of these?', ['one', 'two', 'three'], {default: nil})
What is your favorite number of these?
1. one
2. two
3. three

=> nil

> HighlineWrapper.new.ask_multiple_choice('What is your favorite number of these?', ['one', 'two', 'three'], {default: nil, with_index: true})
What is your favorite number of these?
1. one
2. two
3. three

=> nil
```

</details>

### Multiple choice "checkbox" question

Question configuration options:
* `with_indexes`: defaults to `false` (particularly handy when there may be duplicate-named but different items in the list—think Sally with ID 45 and Sally with ID 72)
* `defaults`: defaults to `[]`
* `required`: defaults to `false`

Notes:
* If `required` is `true`, the question will repeat until the user answers the question
* If `required` is `true`, then the `defaults` value will be ignored (this value is defaulting to `[]`, but could be set to whatever and the code won't care... the question is required)
* If `defaults` is `[]` and `required` is `false`, then the method will return an empty array
* If `with_indexes` is `true`, an array of hashes will be returned with the choice AND the index (of the selection in the original `choices` array) in each hash
  * e.g. `[{ value: 'a', index: 0 }, { value: 'c', index: 2 }]`
* If `with_indexes` is `false`, then an hashes will be returned where each hash only has a value
  * e.g. `[{ value: 'a' }, { value: 'c' }]`

<details><summary>Examples</summary>

```ruby
> HighlineWrapper.new.ask_checkbox("What are your favorite numbers of these?", ['one', 'two',
'three'])
What are your favorite numbers of these?
1. one
2. two
3. three
1, 3
=> [{:value=>"one"}, {:value=>"three"}]

> HighlineWrapper.new.ask_checkbox("What are your favorite numbers of these?", ['one', 'two','three'] ,{with_indexes: true})
What are your favorite numbers of these?
1. one
2. two
3. three
1, 3
=> [{:value=>"one", :index=>0}, {:value=>"three", :index=>2}]

> HighlineWrapper.new.ask_checkbox("What are your favorite numbers of these?", ['one', 'two',
'three'], {defaults: ['two', 'three']})
What are your favorite numbers of these?
1. one
2. two
3. three

=> [{:value=>"two"}, {:value=>"three"}]

> HighlineWrapper.new.ask_checkbox("What are your favorite numbers of these?", ['one', 'two','three'], {required: true, with_indexes: true})
What are your favorite numbers of these?
1. one
2. two
3. three

This question is required.

What are your favorite numbers of these?
1. one
2. two
3. three
2
=> [{:value=>"two", :index=>1}]

> HighlineWrapper.new.ask_checkbox("What are your favorite numbers of these?", ['one', 'two',
'three'], {required: true, with_indexes: false})
What are your favorite numbers of these?
1. one
2. two
3. three

This question is required.

What are your favorite numbers of these?
1. one
2. two
3. three
1
=> [{:value=>"one"}]

> HighlineWrapper.new.ask_checkbox("What are your favorite numbers of these?", ['one', 'two','three'], {defaults: []})
What are your favorite numbers of these?
1. one
2. two
3. three

=> []

> HighlineWrapper.new.ask_checkbox("What are your favorite numbers of these?", ['one', 'two','three'], {defaults: [], with_indexes: true})
What are your favorite numbers of these?
1. one
2. two
3. three

=> []
```

</details>

## Tests

To run the tests, run `bundle exec rspec` from the command line. GitHub Actions will also run the tests upon every commit to make sure they're up to date and that everything is working correctly. Locally, you can also run `bundle exec guard` to automatically run tests as you develop!

## Contributing

To submit a feature request, bug ticket, etc, please submit an official [GitHub Issue](https://github.com/emmahsax/highline_wrapper/issues/new).

To report any security vulnerabilities, please view this project's [Security Policy](https://github.com/emmahsax/highline_wrapper/security/policy).

When interacting with this repository, please follow [Contributor Covenant's Code of Conduct](https://contributor-covenant.org).

## Releasing

To make a new release of this gem:

1. Merge the pull request via the big green button
2. Run `git tag vX.X.X` and `git push --tag`
3. Make a new release [here](https://github.com/emmahsax/highline_wrapper/releases/new)
4. Run `gem build *.gemspec`
5. Run `gem push *.gem` to push the new gem to RubyGems
6. Run `rm *.gem` to clean up your local repository

To set up your local machine to push to RubyGems via the API, see the [RubyGems documentation](https://guides.rubygems.org/publishing/#publishing-to-rubygemsorg).
