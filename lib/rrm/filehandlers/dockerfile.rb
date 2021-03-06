module Rrm
  class Dockerfile
    FILENAME = 'Dockerfile'
    PATTERN  = /^FROM ruby:([\d.]{1,5})/

    attr_accessor :git, :content, :new_version

    def initialize(git)
      @content = File.read("#{git.dir.path}/#{FILENAME}")
      @git = git
    rescue
      @content = nil
    end

    def update!(new_version)
      new_content = content.gsub(/(^FROM ruby:)([\d.]{1,5})/, ('\1'+new_version))
      file = File.open("#{git.dir.path}/#{FILENAME}", 'w')
      file.puts new_content
      file.close
      git.commit_all("Updating #{FILENAME} to Ruby #{new_version}")
    rescue
      Rrm.logger.debug("Could not update #{FILENAME} because #{$!.message}")
      nil
    end

    def ruby_version
      @ruby_version ||= content.match(PATTERN).captures.first
    end
  end
end
