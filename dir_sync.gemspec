Gem::Specification.new do |spec|
  spec.name = 'dir_sync'
  spec.version = '0.1.0'
  spec.summary = 'directory synchroniser'
  spec.description = <<-EOF
Bidirectional directory synchronisation for any number of directories
EOF

  spec.authors << 'Mark Ryall'
  spec.email = 'mark@ryall.name'
  spec.homepage = 'http://github.com/markryall/dir_sync'
 
  spec.files = Dir['lib/**/*'] +
               Dir['spec/**/*'] +
               Dir['bin/*'] +
               ['README.rdoc', 'MIT-LICENSE', 'HISTORY.rdoc', 'Rakefile', '.gemtest']

  spec.executables << 'dir_sync'
  spec.executables << 'drain'

  spec.add_development_dependency 'rake', '~>0'
  spec.add_development_dependency 'rspec', '~>2'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'aruba'
end
