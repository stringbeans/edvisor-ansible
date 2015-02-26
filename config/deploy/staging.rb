set :branch, 'development'
set :stage, 'staging'
set :no_deploytags, true

ec2_role :api,
  user: 'deploy'