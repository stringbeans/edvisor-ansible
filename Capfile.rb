# Load DSL and Setup Up Stages
require 'capistrano/setup'

# Includes default deployment tasks
require 'capistrano/deploy'

# include deploy tags
require 'capistrano/deploytags'

# Include capistrano ec2
require "cap-ec2/capistrano"

# NPM
require 'capistrano/npm'

# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
Dir.glob('lib/capistrano/tasks/*.cap').each { |r| import r }