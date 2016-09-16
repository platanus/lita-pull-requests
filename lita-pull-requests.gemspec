Gem::Specification.new do |spec|
  spec.name          = "lita-pull-requests"
  spec.version       = "0.1.0"
  spec.authors       = ["Arturo Puente"]
  spec.email         = ["arturo@platan.us"]
  spec.description   = "A description"
  spec.summary       = "A summary"
  spec.homepage      = "https://github.com/platanus/lita-pull-requests"
  spec.license       = "MIT"
  spec.metadata      = { "lita_plugin_type" => "handler" }

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "lita", ">= 4.7"
  spec.add_runtime_dependency "octokit", "~> 4.0"
  spec.add_runtime_dependency "rufus-scheduler", '2.0.24'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "rspec", ">= 3.0.0"
end
