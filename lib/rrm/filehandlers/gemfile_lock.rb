require 'docker'

module Rrm
  class GemfileLock
    GEMFILE = 'Gemfile'
    FILENAME = 'Gemfile.lock'
    TIMEOUT_SECONDS = 600

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
      container = Docker::Container.create('Cmd' => 'bundle', 'Image' => "ruby:#{new_version}", 'Env' => env_options)
      container.store_file("/#{GEMFILE}", File.read("#{git.dir.path}/#{GEMFILE}"))
      container.store_file("/#{FILENAME}", File.read("#{git.dir.path}/#{FILENAME}")) unless update_gems
      container.start
      Rrm.logger.debug "Running 'bundle' inside Docker, please wait. Timeout is #{TIMEOUT_SECONDS} seconds"
      container.wait(TIMEOUT_SECONDS)
      new_content = container.read_file("/#{FILENAME}")
      container.stop
      file = File.open("#{git.dir.path}/#{FILENAME}", 'w')
      file.puts new_content
      file.close
      git.commit_all(commit_message(new_version))
    rescue StandardError
      Rrm.logger.warn("#{FILENAME} update failed: #{$!.message}")
      raise Rrm::FailRepository, "Updating the #{FILENAME} failed."
    end

    private

    def env_options
      arr = []
      $env_variables.each do |e|
        arr << "#{e}=#{ENV[e]}"
      end
      Rrm.logger.debug "Passing #{$env_variables} to Docker as Env"
      arr
    end

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
