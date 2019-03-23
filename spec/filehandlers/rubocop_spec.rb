RSpec.describe Rrm::Rubocop do
  let(:file_content) do
    <<~HEREDOC
      AllCops:
        TargetRubyVersion: 2.3

      Style/Documentation:
        Enabled: false
    HEREDOC
  end

  let(:subject) { described_class.new(file_content) }

  it 'detects Ruby version' do
    expect(subject.ruby_version).to eq '2.3'
  end
end
