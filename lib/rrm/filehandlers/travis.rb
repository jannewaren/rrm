module Rrm
  class Travis
    FILENAME = '.travis.yml'
    PATTERN  = /rvm:\s+-\s(\d.\d.\d)/

    def initialize(content)
      @content = content
    end

    def ruby_version
      @ruby_version ||= @content.match(PATTERN).captures.first
    end
  end
end
