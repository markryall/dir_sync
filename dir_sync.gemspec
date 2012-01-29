Gem::Specification.new do |spec|
  spec.name = 'dir_sync'
  spec.version = '0.1.1'
  spec.summary = 'directory synchroniser'
  spec.description = <<-EOF
Multidirectional directory synchronisation for any number of directories
EOF

  spec.authors = ['Mark Ryall','James Ottaway']
  spec.email = 'mark@ryall.name'
  spec.homepage = 'http://github.com/markryall/dir_sync'
 
  spec.files = Dir['bin/*'] +
               Dir['features/**/*'] +
               Dir['lib/**/*'] +
               Dir['spec/**/*'] +
               ['.gemtest', 'HISTORY.rdoc', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']

  spec.required_ruby_version = '>= 1.9'
  spec.executables = ['dir_sync', 'drain']

  spec.add_development_dependency 'rake', '~>0'
  spec.add_development_dependency 'rspec', '~>2'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'growl'
  spec.add_development_dependency 'aruba'
end
