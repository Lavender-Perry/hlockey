# frozen_string_literal: true

require_relative('lib/hlockey/version')

Gem::Specification.new do |s|
  s.name = 'hlockey'
  s.version = Hlockey::VERSION
  s.summary = "Hlockey season #{Hlockey::VERSION}."
  s.description = 'Hockey sports sim.'
  s.authors = ['Lavender Perry']
  s.email = 'endie2@protonmail.com'
  s.license = 'LicenseRef-LICENSE.md'
  s.homepage = 'https://github.com/Lavender-Perry/hlockey'
  s.metadata = { 'source_code_uri' => s.homepage }
  s.files = Dir['lib/**/*']
  s.executables = ['hlockey']
end
