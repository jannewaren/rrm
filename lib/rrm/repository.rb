require 'git'
require 'securerandom'

module Rrm

  class FailRepository < StandardError; end
  class Repository
    CLONEDIR = "/tmp/rrm/#{SecureRandom.uuid}/"

    attr_accessor :url, :name, :level
    attr_accessor :major, :minor, :patch
    attr_accessor :dockerfile, :gemfile, :gemfile_lock, :gitlab_ci, :rubocop, :travis
    attr_accessor :branch_name

    def initialize(url, level, update_gems)
      @url = url
      @name = url.split('/').last.gsub('.git', '')
      @dockerfile   = Rrm::Dockerfile.new(git)
      @gemfile      = Rrm::Gemfile.new(git)
      @gemfile_lock = Rrm::GemfileLock.new(git, update_gems)
      @gitlab_ci    = Rrm::GitlabCi.new(git)
      @rubocop      = Rrm::Rubocop.new(git)
      @travis       = Rrm::Travis.new(git)
      @major, @minor, @patch = current_version.split('.')
      @level = level
    end

    def git
      @git ||= clone_or_update_git
    end

    def current_version
      @current_version ||= fetch_current_version
    end

    def new_version
      @new_version ||= decide_new_ruby_version
    end

    def update!
      Rrm.logger.debug "Updating #{name} from #{current_version} to #{new_version}"
      create_branch
      dockerfile.update!(new_version)
      gemfile.update!(new_version)
      gemfile_lock.update!(new_version)
      gitlab_ci.update!(new_version)
      rubocop.update!(new_version.split('.')[0..1].join('.'))
      travis.update!(new_version)
    end

    def push!
      git.push('origin', @branch_name)
    end

    private

    def create_branch
      @branch_name = "#{Time.new.strftime('%Y%m%d%H%M%S')}_upgrade_to_ruby_#{new_version.delete('.')}"
      git.branch(@branch_name).checkout
    end

    def all
      Rrm.all_ruby_versions.dup
    end

    def decide_new_ruby_version
      case level
      when :major_next
        major_next
      when :major_latest
        major_latest
      when :minor_next
        minor_next
      when :minor_latest
        minor_latest
      when :patch_next
        patch_next
      when :patch_latest
        patch_latest
      end
    end

    def major_next
      next_major = (major.to_i+1).to_s
      all.select{|v| v.start_with?("#{next_major}.")}.last
    rescue
      nil
    end

    def major_latest
      next_major = (major.to_i+1).to_s
      all.select{|v| v > next_major}.last
    rescue
      nil
    end

    def minor_next
      next_minor = (minor.to_i+1).to_s
      all.select{|v| v.start_with?("#{major}.#{next_minor}.")}.last
    rescue
      nil
    end

    def minor_latest
      all.select{|v| v.start_with?("#{major}.")}.last
    rescue
      nil
    end

    def patch_next
      next_patch = (patch.to_i+1).to_s
      all.select{|v| v == ("#{major}.#{minor}.#{next_patch}")}.last
    rescue
      nil
    end

    def patch_latest
      all.select{|v| v.start_with?("#{major}.#{minor}.")}.last
    rescue
      nil
    end

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

    def fetch_current_version
      line = git.object('master:Gemfile').grep('ruby ').flatten.last
      return nil unless line.flatten.last.include?('ruby ')
      line.flatten.last.match(/(\d.\d.\d)/).to_s
    rescue
      Rrm.logger.warn("fetch_current_version not found for #{name} - #{$!.message} - #{$!.backtrace}")
      nil
    end
  end
end
