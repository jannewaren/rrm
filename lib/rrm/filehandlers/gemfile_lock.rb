require 'docker'

module Rrm
  class GemfileLock
    GEMFILE = 'Gemfile'
    FILENAME = 'Gemfile.lock'

    attr_accessor :git, :content, :new_version, :update_gems

    def initialize(git, update_gems)
      @content = File.read("#{git.dir.path}/#{FILENAME}")
      @git = git
      @update_gems = update_gems
    rescue
      @content = nil
    end

    def update!(new_version)
      image = Docker::Image.create('fromImage' => "ruby:#{new_version}")
      container = Docker::Container.create('Cmd' => 'bundle', 'Image' => "ruby:#{new_version}")
      container.store_file("/#{GEMFILE}", File.read("#{git.dir.path}/#{GEMFILE}"))
      container.store_file("/#{FILENAME}", File.read("#{git.dir.path}/#{FILENAME}")) unless update_gems
      container.start
      puts "bundle install running... please wait"
      container.wait(120)
      new_content = container.read_file("/#{FILENAME}")
      container.stop
      file = File.open("#{git.dir.path}/#{FILENAME}", 'w')
      file.puts new_content
      file.close
      git.commit_all(commit_message(new_version))
    end

    private

    def commit_message(new_version)
      msg = "Updating #{FILENAME} to Ruby #{new_version}"
      msg << " and updating #{number_of_gem_updates} gems" if update_gems
      msg
    end

    def number_of_gem_updates
      git.diff.first.patch.split("\n").select{|s| s.start_with?('+')}.select{|s| s.include?("(")}.size
    rescue
      "?"
    end
  end
end
