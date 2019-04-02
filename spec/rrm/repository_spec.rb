RSpec.describe Rrm::Repository do
  describe 'when initializing with valid url' do
    let(:url) { 'git@gitlab.com:kickban/form-kickban-fi.git' }
    let(:subject) { described_class.new(url) }

    it 'is able to clone the repo' do
      expect(subject.git).to be_a(Git::Base)
    end

    it 'is able to detect current Ruby version using Gemfile' do
      expect(subject.current_ruby_version).to eq('2.6.0')
    end
  end
end
