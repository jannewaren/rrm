# rrm - Ruby Repository Manager

Trying to make the repetitive task of updating Ruby (and gem dependencies) for multiple projects a bit less painful.

## What does it do?

Give it some URL's to git repositories, and rrm will:
* Clone each repository
* Give you options (unless you chose already) to update to the latest patch, minor or major version of Ruby by updating
  * Gemfile
  * .gitlab-ci.yml
  * .travis.yml
  * .rubocop.yml
  * Dockerfile
* Run bundler inside Docker (with the new Ruby version) to upgrade Gemfile.lock

## Running it

### Requirements

* Ruby
* Docker

Tested on macOS Mojave with Ruby 2.6.2 and Docker 18.09.2.

### Usage

TODO: Write usage instructions here

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jannewaren/rrm. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Rrm project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/jannewaren/rrm/blob/master/CODE_OF_CONDUCT.md).
