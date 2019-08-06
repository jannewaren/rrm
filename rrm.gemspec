lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rrm/version'

Gem::Specification.new do |spec|
  spec.name          = 'rrm'
  spec.version       = Rrm::VERSION
  spec.authors       = ['Janne Warén']
  spec.email         = ['janne.waren@iki.fi']

  spec.summary       = %q{Updating Ruby and Gems easily on multiple projects}
  spec.description   = %q{Makes updating Gemfile and friends easy for a lot of projects at once.}
  spec.homepage      = 'https://github.com/jannewaren/rrm'
  spec.license       = 'MIT'

  if spec.respond_to?(:metadata)
    spec.metadata['homepage_uri']    = spec.homepage
    spec.metadata['source_code_uri'] = 'https://github.com/jannewaren/rrm'
    spec.metadata['changelog_uri']   = 'https://github.com/jannewaren/rrm/releases'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'awesome_print'

  spec.add_runtime_dependency 'git', '~> 1.5'
  spec.add_runtime_dependency 'highline', '~> 2.0'
  spec.add_runtime_dependency 'nokogiri', '~> 1.10'
  spec.add_runtime_dependency 'docker-api', '~> 1.34'
  spec.add_runtime_dependency 'slop', '~> 4.6'
  spec.add_runtime_dependency 'tty-progressbar', '~> 0.16.0'
end
