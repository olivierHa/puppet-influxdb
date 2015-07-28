require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'

PuppetLint.configuration.send('disable_class_inherits_from_params_class')
PuppetLint.configuration.send('disable_empty_string_assignment')

Rake::Task[:lint].clear
PuppetLint::RakeTask.new :lint do |config|
  config.ignore_paths = ["spec/**/*.pp", "pkg/**/*.pp", "vendor/**/*.pp"]
  config.disable_checks = ['80chars','class_inherits_from_params_class']
  config.fail_on_warnings = true
  config.with_context = true
end



PuppetSyntax.exclude_paths = ["spec/fixtures/**/*.pp", "vendor/**/*"]
