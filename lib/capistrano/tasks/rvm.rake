namespace :rvm do
  task :update_key do
    on roles(fetch(:rvm1_roles, :all)) do
      execute :gpg, '--keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3'
    end
  end

  task :install_bundler do
    on roles(fetch(:rvm1_roles, :all)) do
      execute :gem, 'install', 'bundler'
    end
  end
end

before 'deploy', 'rvm1:install:rvm'
before 'deploy', 'rvm1:install:ruby'
before 'deploy', 'rvm1:alias:create'
before 'deploy', 'rvm1:install:gems'

before 'rvm1:install:gems', 'rvm:install_bundler'
before 'rvm1:install:rvm', 'rvm:update_key'