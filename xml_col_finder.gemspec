Gem::Specification.new do |s|
  s.name = 'xml_col_finder'
  s.version = '0.2.0'
  s.summary = 'Attempts to return the relative xpath for each ' +
      'element containing text.'
  s.authors = ['James Robertson']
  s.files = Dir['lib/xml_col_finder.rb']
  s.add_runtime_dependency('rexle', '~> 1.5', '>=1.5.14')
  s.signing_key = '../privatekeys/xml_col_finder.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'digital.robertson@gmail.com'
  s.homepage = 'https://github.com/jrobertson/xml_col_finder'
end
