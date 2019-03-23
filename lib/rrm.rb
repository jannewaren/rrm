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
