# rrm - Ruby Repository Manager

Trying to make the repetitive task of updating Ruby (and gem dependencies) for multiple projects a bit less painful.

## What does it do?

Give it some URL's to git repositories, and rrm will:
* Clone each repository
* Update to the latest patch, minor or major version of Ruby by updating
  * Dockerfile
  * Gemfile
  * Gemfile.lock (by running bundle via Docker)
  * .gitlab-ci.yml
  * .rubocop.yml
  * .travis.yml
* Push changes in a new branch to remote

Staying up to date with new Ruby versions on tens of projects should be easier than ever!

Optionally you can update gems as well, either all of them or just some groups like dev and test.

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


## TODO

* Interactive mode with some fancy ncurses dialogs etc
* Only update gems in selected groups (to easily update development dependencies more often for example)
* Ways to limit or increase output (--quiet mode and --verbose mode)
* Make proper documentation and refactor all the classes so it could be used as a gem/library inside other projects. For example a Slack bot to update things?
* 