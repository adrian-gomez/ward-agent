job_type :rvm_wrapped_bin, 'cd :path && ~/.rvm/wrappers/ward-agent-ruby/bundle exec bin/:task :output'

every 1.minute, roles: [:app] do
  rvm_wrapped_bin :run
end