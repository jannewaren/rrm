require 'highline'
require 'git'
require 'open-uri'
require 'nokogiri'
require 'docker'
require 'slop'

require 'rrm/version'
require 'rrm/repository'
require 'rrm/filehandlers/dockerfile'
require 'rrm/filehandlers/gemfile'
require 'rrm/filehandlers/gemfile_lock'
require 'rrm/filehandlers/gitlab-ci'
require 'rrm/filehandlers/rubocop'
require 'rrm/filehandlers/travis'

module Rrm
  class Error < StandardError; end
  # Your code goes here...
end
