Gem::Specification.new do |s|
  s.name               = "petstore"
  s.version            = "0.0.1"
  s.default_executable = "petstore"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Alexei Zhuravlev"]
  s.date = %q{2016-06-08}
  s.description = %q{Test task to create ruby library for work with API petstore.swagger.io}
  s.email = %q{serangu@yandex.ru}
  s.files = ["lib/petstore.rb", "lib/petstore/objectstore.rb", "lib/petstore/pet.rb", "lib/petstore/conf.rb"]
  s.test_files = ["spec/petstore_spec.rb", "spec/spec_helper.rb"]
  s.homepage = %q{}
  s.require_paths = ["lib", "spec"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Give me a job!!!}
  
  s.add_runtime_dependency 'json', '~> 1.8', '>= 1.8.3'
  
  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

