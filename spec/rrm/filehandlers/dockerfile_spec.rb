RSpec.describe Rrm::Dockerfile do
  let(:subject) { described_class.new(file_content) }

  describe 'for minor versions (eg 2.3.3)' do
    let(:file_content) do
      <<~HEREDOC
        FROM ruby:2.3.3-alpine as build
        
        ENV BUNDLE_HOME application/
        WORKDIR application/
        COPY Gemfile Gemfile.lock application/
        RUN bundle install --deployment
        
        FROM ruby:2.3.3-alpine
        
        COPY --from=build application ./
        EXPOSE 9292
      HEREDOC
    end

    it 'detects Ruby version' do
      expect(subject.ruby_version).to eq '2.3.3'
    end
  end
  
  describe 'for minor versions (eg 2.3)' do
    let(:file_content) do
      <<~HEREDOC
        FROM ruby:2.3 as build
        
        ENV BUNDLE_HOME application/
        WORKDIR application/
        COPY Gemfile Gemfile.lock application/
        RUN bundle install --deployment
        
        FROM ruby:2.3
        
        COPY --from=build application ./
        EXPOSE 9292
      HEREDOC
    end

    it 'detects Ruby version' do
      expect(subject.ruby_version).to eq '2.3'
    end
  end

  describe 'for major versions (eg 2)' do
    let(:file_content) do
      <<~HEREDOC
        FROM ruby:2 as build
        
        ENV BUNDLE_HOME application/
        WORKDIR application/
        COPY Gemfile Gemfile.lock application/
        RUN bundle install --deployment
        
        FROM ruby:2
        
        COPY --from=build application ./
        EXPOSE 9292
      HEREDOC
    end

    it 'detects Ruby version' do
      expect(subject.ruby_version).to eq '2'
    end
  end
end