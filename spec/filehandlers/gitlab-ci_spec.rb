RSpec.describe Rrm::GitlabCi do
  

  let(:subject) { described_class.new(file_content) }

  describe 'for minor versions (eg 2.6.2)' do
    let(:file_content) do
      <<~HEREDOC
        test1:
          image: ruby:2.6.2
          services:
            - postgres
            - redis
          script:
            - test1 project
      HEREDOC
    end

    it 'detects Ruby version' do
      expect(subject.ruby_version).to eq '2.6.2'
    end
  end

  describe 'for minor versions (eg 2.6)' do
    let(:file_content) do
      <<~HEREDOC
        test1:
          image: ruby:2.6
          services:
            - postgres
            - redis
          script:
            - test1 project
      HEREDOC
    end

    it 'detects Ruby version' do
      expect(subject.ruby_version).to eq '2.6'
    end
  end

  describe 'for major versions (eg 2)' do
    let(:file_content) do
      <<~HEREDOC
        test1:
          image: ruby:2
          services:
            - postgres
            - redis
          script:
            - test1 project
      HEREDOC
    end

    it 'detects Ruby version' do
      expect(subject.ruby_version).to eq '2'
    end
  end
end
