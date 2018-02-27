lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'date'
require_relative 'lib/umarcts-sensu-plugins-slurm'

Gem::Specification.new do |s|
  s.authors                = ['David Rhey', 'Daniel Barker']

  s.date                   = Date.today.to_s
  s.description            = 'Sensu + Slurm/SchedMD'
  s.email                  = 'drhey@umich.edu'
  s.executables            = Dir.glob('bin/**/*.rb').map { |file| File.basename(file) }
  s.files                  = Dir.glob('{bin,lib}/**/*') + %w(LICENSE README.md CHANGELOG.md)
  s.homepage               = 'https://github.com/drhey/umarcts-sensu-plugins-slurm'
  s.license                = 'MIT'
  s.metadata               = { 'maintainer'         => 'sensu-plugin',
                               'development_status' => 'active',
                               'production_status'  => 'stable',
                               'release_draft'      => 'false',
                               'release_prerelease' => 'false' }
  s.name                   = 'umarcts-sensu-plugins-slurm'
  s.platform               = Gem::Platform::RUBY
  s.post_install_message   = 'You can use the embedded Ruby by setting EMBEDDED_RUBY=true in /etc/default/sensu'
  s.require_paths          = ['lib']
  s.required_ruby_version  = '>= 2.0.0'
  s.summary                = 'Sensu + Slurm/SchedMD'
  s.test_files             = s.files.grep(%r{^(test|spec|features)/})
  s.version                = UMARCTSSensuPluginsSlurm::Version::VER_STRING

  s.add_runtime_dependency 'sensu-plugin', '~> 1.2'
  s.add_runtime_dependency 'rest-client',       '1.8.0'
  s.add_runtime_dependency 'chronic_duration',  '0.10.6'

  s.add_development_dependency 'bundler',                   '~> 1.7'
  s.add_development_dependency 'codeclimate-test-reporter', '~> 0.4'
  s.add_development_dependency 'github-markup',             '~> 1.3'
  s.add_development_dependency 'pry',                       '~> 0.10'
  s.add_development_dependency 'rubocop',                   '~> 0.49.0'
  s.add_development_dependency 'rspec',                     '~> 3.1'
  s.add_development_dependency 'rake',                      '~> 10.0'
  s.add_development_dependency 'redcarpet',                 '~> 3.2'
  s.add_development_dependency 'yard',                      '~> 0.9.11'
end
