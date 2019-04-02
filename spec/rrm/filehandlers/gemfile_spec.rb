RSpec.describe Rrm::Gemfile do
  let(:file_content) do
    <<~HEREDOC
      source 'https://rubygems.org'

      ruby '2.6.0'

      gem 'rake', '~> 10.4'
      gem 'rspec'
      gem 'rspec-puppet', '~> 2.6.0'
    HEREDOC
  end

  let(:subject) { described_class.new(file_content) }

  it 'detects Ruby version' do
    expect(subject.ruby_version).to eq '2.6.0'
  end
end
