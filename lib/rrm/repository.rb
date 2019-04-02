require 'git'
require 'securerandom'

module Rrm
  class Repository
    CLONEDIR = "/tmp/rrm/#{SecureRandom.uuid}/"

    attr_accessor :url, :name
    attr_accessor :new_version

    def initialize(url)
      @url = url
      @name = url.split('/').last.gsub('.git', '')
    end

    def git
      @git ||= clone_or_update_git
    end

    def current_ruby_version
      @current_ruby_version ||= fetch_current_ruby_version
    end

    private

    def clone_or_update_git
      git = Git.open("#{CLONEDIR}#{name}")
      git.pull('origin', 'master')
      Rrm.logger.debug("Using previous directory #{CLONEDIR}#{name}")
      git
    rescue ArgumentError
      Rrm.logger.debug("Could not Git.open - reverting to Git.clone instead")
      Git.clone(url, name, path: CLONEDIR) 
    rescue
      Rrm.logger.error("Could not open or clone #{url} because #{$!.message} - #{$!.backtrace}")
      nil
    end

    def fetch_current_ruby_version
      line = git.gblob('Gemfile').grep('ruby ')['Gemfile'].flatten
      return nil unless line.last.include?('ruby ')
      line.last.match(/(\d.\d.\d)/).to_s
    rescue
      Rrm.logger.warn("current_ruby_version not found for #{name} - #{$!.message} - #{$!.backtrace}")
      nil
    end
  end
end
