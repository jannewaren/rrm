RSpec.describe Rrm do
  it 'has a version number' do
    expect(Rrm::VERSION).not_to be nil
  end

  describe '#fetch_all_ruby_versions'  do
    it 'gets all', vcr: { cassette_name: 'fetch_all_ruby_versions' } do
      expect(described_class.all_ruby_versions).is_a? Array
      expect(described_class.all_ruby_versions).to include '1.9.3'
      expect(described_class.all_ruby_versions).to include '2.1.2'
      expect(described_class.all_ruby_versions).to include '2.2.0'
      expect(described_class.all_ruby_versions).to include '2.3.3'
      expect(described_class.all_ruby_versions).to include '2.5.1'
      expect(described_class.all_ruby_versions).to include '2.6.2'
      expect(described_class.all_ruby_versions).to_not include '2.4.0-preview1'
      expect(described_class.all_ruby_versions).to_not include '2.6.0-rc2'
    end
  end
end
