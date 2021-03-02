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

### Usage

Once this gem is installed, you can then initiate a new `HighlineWrapper` object:

```ruby
HighlineWrapper.new
```

Then, add this to the top of your file (or to your gem):

```ruby
require 'highline_wrapper'
```

Then, you can call its questions to receive answers:

```ruby
> HighlineWrapper.new.ask('What is your favorite number?')
What is your favorite number?
four
=> "four"

> HighlineWrapper.new.ask_yes_no('Do you like Ruby?')
Do you like Ruby?
no
=> false

> HighlineWrapper.new.ask_yes_no('Do you like Ruby?')
Do you like Ruby?
yes
=> true

HighlineWrapper.new.ask_multiple_choice('What is your favorite number of t
hese?', ['one', 'two', 'three'])
What is your favorite number of these?
1. one
2. two
3. three
2
=> "two"

> HighlineWrapper.new.ask_checkbox("What are your favorite numbers of these?
", ['one', 'two','three'])
What are your favorite numbers of these?
1. one
2. two
3. three
1,3
=> ["one", "three"]

> HighlineWrapper.new.ask_checkbox("What are your favorite numbers of these?
", ['one', 'two','three'], with_indexes: true)
What are your favorite numbers of these?
1. one
2. two
3. three
1, 3
=> [{:choice=>"one", :index=>0}, {:choice=>"three", :index=>2}]
```

### Tests

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
