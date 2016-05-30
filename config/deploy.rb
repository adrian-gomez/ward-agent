lock '3.5.0'

set :application, 'ward-agent'
set :repo_url, 'git@github.com:adrian-gomez/ward-agent.git'

set :deploy_to, "/home/ubuntu/#{fetch(:application)}"

set :linked_files, fetch(:linked_files, []).push('config/settings.yml')

set :linked_dirs, fetch(:linked_dirs, []).push('log')

set :rvm1_ruby_version, '2.2.3'
set :rvm1_alias_name, 'ward-agent-ruby'

set :whenever_roles, :app