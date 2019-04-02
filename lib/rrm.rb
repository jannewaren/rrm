require 'open-uri'
require 'nokogiri'
require 'docker'

require_relative 'rrm/version'
require_relative 'rrm/repository'
require_relative 'rrm/updater'
require_relative 'rrm/filehandlers/dockerfile'
require_relative 'rrm/filehandlers/gemfile'
require_relative 'rrm/filehandlers/gemfile_lock'
require_relative 'rrm/filehandlers/gitlab-ci'
require_relative 'rrm/filehandlers/rubocop'
require_relative 'rrm/filehandlers/travis'

module Rrm
  class Error < StandardError; end

  def self.logger
   @logger ||= Logger.new(STDOUT)
  end

  def self.all_ruby_versions
    @all_ruby_versions ||= fetch_all_ruby_versions
  end

  def self.fetch_all_ruby_versions
    versions = []
    html = open('https://www.ruby-lang.org/en/downloads/releases/')
    doc = Nokogiri::HTML(html)
    rows = doc.search('tr')
    rows.each do |row|
      ver = row.search('td').first.text
      next if ver.include?('preview')
      next if ver.include?('rc')
      versions << ver.split(' ').last
    rescue
      next
    end
    versions.compact.sort
  end
end
