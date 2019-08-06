module Rrm
  class Updater
    require 'tty-progressbar'

    attr_accessor :options
    attr_accessor :level

    # Needs options as a hash. Options follow the naming from
    # the console application in bin/rrm. Example
    #
    # { :urls => [
    #         [0] "git@gitlab.com:kickban/form-kickban-fi.git"
    #     ],
    #       :patch_next => false,
    #       :patch_latest => true,
    #       :minor_next => false,
    #       :minor_latest => false,
    #       :major_next => false,
    #       :major_latest => false,
    #       :update_gems => false
    #     }
    def initialize(options)
      $env_variables = options[:env]

      @options = options
      if options[:major_latest]
        @level = :major_latest
      elsif options[:major_next]
        @level = :major_next
      elsif options[:minor_latest]
        @level = :minor_latest
      elsif options[:minor_next]
        @level = :minor_next
      elsif options[:patch_latest]
        @level = :patch_latest
      elsif options[:patch_next]
        @level = :patch_next
      end
    end

    def update_all
      Rrm.logger.debug "Available normal Ruby versions: #{Rrm.all_ruby_versions}"
      all_repositories.each do |repository|
        puts "#{repository.name} from #{repository.current_version} to #{repository.new_version}"
      end

      bar = TTY::ProgressBar.new("Running upgrades (:current of :total) [:bar]", total: all_repositories.size, width: 30)
      all_repositories.each do |repository|
        repository.update!
        bar.advance(1)
      end

      bar = TTY::ProgressBar.new("Pushing branches (:current of :total) [:bar]", total: all_repositories.size, width: 30)
      all_repositories.each do |repository|
        repository.push!
        bar.advance(1)
      end

      puts "Pushed branches:"
      all_repositories.each do |repository|
        puts "#{repository.branch_name} (#{repository.git.remote.url})"
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
        repos << Rrm::Repository.new(url, level, options[:update_gems])
        bar.advance(1)
      end
      repos
    end
  end
end
