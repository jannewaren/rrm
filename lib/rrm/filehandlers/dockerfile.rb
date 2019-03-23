module Rrm
  class Dockerfile
    FILENAME = 'Dockerfile'
    PATTERN  = /^FROM ruby:([\d.]{1,5})/

    def initialize(content)
      @content = content
    end

    def ruby_version
      @ruby_version ||= @content.match(PATTERN).captures.first
    end
  end
end
