module Rrm
  class Gemfile
    FILENAME = 'Gemfile'
    PATTERN = /^ruby ['"](\d.\d.\d)['"]/

    def initialize(content)
      @content = content
    end

    def ruby_version
      @ruby_version ||= @content.match(PATTERN).captures.first
    end
  end
end
