# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = 'hlockey'
  s.version = '1'
  s.summary = "Hlockey season #{s.version}."
  s.description = 'Hockey sports sim.'
  s.authors = ['Lavender Perry']
  s.email = 'endie2@protonmail.com'
  s.license = 'LicenseRef-LICENSE.md'
  s.homepage = 'https://github.com/Lavender-Perry/hlockey'
  s.metadata = { 'source_code_uri' => s.homepage }
  s.files = Dir['lib/**/*']
  s.executables = ['hlockey']
end
