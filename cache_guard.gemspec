Gem::Specification.new do |s|
  s.name        = "cache_guard"
  s.version     = "1.0.0"
  s.date        = "2016-01-13"
  s.summary     = "Allows you to protect the execution of a block against concurrency."
  s.authors     = ["Duarte Henriques", "Miguel Teixeira"]
  s.email       = ["duarte.henriques@seedrs.com", "miguel.teixeira@seedrs.com"]
  s.files       = ["lib/cache_guard.rb"]
  s.test_files  = ["spec/lib/cache_guard_spec.rb"]
  s.homepage    = "http://rubygems.org/gems/cache_guard"
  s.license     = "MIT"

  s.add_development_dependency "rspec", "~> 3.4"
  s.add_development_dependency "rubocop", "~> 0.35.1"
end
