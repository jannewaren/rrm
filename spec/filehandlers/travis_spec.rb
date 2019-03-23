RSpec.describe Rrm::Travis do
  let(:file_content) do
    <<~HEREDOC
      ---
      sudo: false
      language: ruby
      cache: bundler
      rvm:
        - 2.6.2
      before_install: gem install bundler -v 2.0.1
    HEREDOC
  end

  let(:subject) { described_class.new(file_content) }

  it 'detects Ruby version' do
    expect(subject.ruby_version).to eq '2.6.2'
  end
end
