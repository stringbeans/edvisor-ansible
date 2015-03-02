set :application, 'edvisor'
set :deploy_to,   "/opt/apps/web/api.edvisor.io"
set :repo_url, 'git@github.com:stringbeans/jsedvisor.git'
set :linked_files, %w(server/config.json server/datasources.json server/pm2.json)
set :linked_dirs, %w{log node_modules}
set :format, :pretty
set :user, "deploy"
set :npm_flags, '--silent'
set :pm2_config, '/opt/apps/web/api.edvisor.io/shared/server/pm2.json'
set :path, "$PATH:/home/deploy/.nvm/current/bin"
set :default_env, {
  "PATH" => fetch(:path)
}

namespace :deploy do


    desc 'Restarting application'
    task :restart do
      on roles(:api) do
          execute "cd #{fetch(:deploy_to)}/current/server && PATH=#{fetch(:path)} pm2 startOrRestart pm2.json"
      end
    end

        desc 'Starting application'
    task :start do
      on roles(:api) do
        execute "cd #{fetch(:deploy_to)}/current/server && PATH=#{fetch(:path)} pm2 start pm2.json"
      end
    end

    desc 'PM2 Kill'
    task :kill do
        on roles(:api) do
        execute "PATH=#{fetch(:path)} pm2 kill && sudo kill $(ps aux | grep 'pm2' | awk '{print $2}')"
      end
    end

    desc 'PM2 Status'
    task :status do
            on roles(:api) do
            execute "PATH=#{fetch(:path)} pm2 status"
        end
    end

    desc 'PM2 List'
    task :list do
            on roles(:api) do
                execute "PATH=#{fetch(:path)} pm2 list"
            end
    end

    desc 'PM2 Logs'
    task :logs do
            on roles(:api) do
                execute "PATH=#{fetch(:path)} pm2 logs"
            end
    end

    desc 'PM2 Flush Logs'
    task :flush do
            on roles(:api) do
                execute "PATH=#{fetch(:path)} pm2 flush"
            end
    end

    desc 'PM2 Reload Logs'
    task :reloadLogs do
            on roles(:api) do
                execute "PATH=#{fetch(:path)} pm2 reloadLogs"
            end
    end

    desc 'Remove PM2 Logs'
    task :removeLogs do
            on roles(:api) do
                execute "sudo rm -rf /var/log/sapi/*"
            end
    end

    desc 'PM2 Version'
    task :pm2version do
            on roles(:api) do
                execute "PATH=#{fetch(:path)} pm2 -v"
            end
    end

    desc 'PM2 Update'
    task :pm2update do
            on roles(:api) do
                execute "npm install pm2@latest -g --unsafe-perm && PATH=#{fetch(:path)} pm2 updatePM2"
            end
    end

    after :updated, 'deploy:restart'

end
