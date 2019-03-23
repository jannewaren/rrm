module Rrm
  class Rubocop
    FILENAME = '.rubocop.yml'
    PATTERN  = /TargetRubyVersion: (\d.\d)/

    def initialize(content)
      @content = content
    end

    def ruby_version
      @ruby_version ||= @content.match(PATTERN).captures.first
    end
  end
end
