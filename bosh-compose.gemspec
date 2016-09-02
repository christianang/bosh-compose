Gem::Specification.new do |s|
  s.name         = 'bosh-compose'
  s.version      = '0.0.1'
  s.date         = '2016-09-01'
  s.summary      = "A cli for BOSH job template rendering."
  s.description  = "A cli for BOSH job template rendering."
  s.authors      = ["Christian Ang"]
  s.email        = 'christian.ang@outlook.com'
  s.homepage     = 'https://github.com/christianang/bosh-compose'
  s.license      = 'MIT'

  s.files        = Dir['bin/**/*', 'lib/**/*'].select{ |f| File.file? f }
  s.require_path = 'lib'
  s.bindir       = 'bin'
  s.executables  = %w(bosh-compose)

  s.add_dependency 'bosh-template', '~>1.3262'
  s.add_dependency 'thor', '~> 0.19.1'

  s.add_development_dependency 'rspec', '~>3.0'
end
