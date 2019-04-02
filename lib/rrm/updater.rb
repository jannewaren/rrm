module Rrm
  class Updater
    require 'tty-progressbar'

    attr_accessor :options

    def initialize(options)
      @options = options 
    end

    def update_all
      all_repositories.each do |repository|
        puts "Repository name: #{repository.name}"
        puts "Current Ruby version: #{repository.current_ruby_version}"
      end
    end

    def all_repositories
      @all_repositories ||=fetch_all_repositories
    end

    private

    def fetch_all_repositories
      bar = TTY::ProgressBar.new("Cloning repositories (:current of :total) [:bar]", total: options[:urls].size, width: 30)
      repos = []
      options[:urls].each do |url|
        repos << Rrm::Repository.new(url)
        bar.advance(1)
      end
      repos
    end
  end
end
