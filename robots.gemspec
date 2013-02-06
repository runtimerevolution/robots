# Provide a simple gemspec so you can easily use your enginex
# project in your rails apps through git.
Gem::Specification.new do |s|
  s.name = "robots"
  s.summary = "A Robots txt DSL"
  s.authors = ["Runtime Revolution"]
  s.files = Dir["{app,lib,config}/**/*"] + ["MIT-LICENSE", "Rakefile", "Gemfile", "README.md"]
  s.version = "0.0.1"
  s.require_paths  = %w(lib)

  s.add_development_dependency("rake")
  s.add_development_dependency("rspec", "~> 2.12.0")
end