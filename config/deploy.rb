# config valid only for Capistrano 3.1
lock '3.2.1'

# アプリケーション名
set :application, 'app1'

set :ssh_options,:port => '16843' #sshのポート指定(デフォルト以外の場合)

# githubのurl。プロジェクトのgitホスティング先を指定する
set :repo_url, 'git@github.com:nekocreate/nginxtest2.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
# デプロイ先のサーバーのディレクトリ。フルパスで指定
# set :deploy_to, '/var/www/my_app'
set :deploy_to, '/home/rails/testapp1'

# Default value for :scm is :git
# Version管理はgit
set :scm, :git

# Default value for :format is :pretty
# ログを詳しく表示
set :format, :pretty

# Default value for :log_level is :debug
# ログを詳しく表示
set :log_level, :debug

# Default value for :pty is false
# sudo に必要
set :pty, true


#rbenvをシステムにインストールしたか? or ユーザーローカルにインストールしたか?
set :rbenv_type, :system # :system or :user

# rubyのversion
set :rbenv_ruby, '2.2.3' # ruby -v で2.2.3p173だった

set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value


# デプロイ先のサーバーの :deploy_to/shared/config/database.yml のシンボリックリンクを
# :deploy_to/current/config/database.yml にはる。
# ただ、注意すべきは、先にshared以下にファイルをアップロードする必要があること
# 上記のファイルアップロード処理は、下記の「upload」タスクで行う
set :linked_files, %w{config/database.yml}




# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# 何世代前までリリースを残しておくか
set :keep_releases, 5

namespace :deploy do

  # 上記linked_filesで使用するファイルをアップロードするタスク
  desc 'Upload database.yml'
  task :upload do
    on roles(:app) do |host|
      if test "[ ! -d #{shared_path}/config ]"
        execute "mkdir -p #{shared_path}/config"
      end
      upload!('config/database.yml', "#{shared_path}/config/database.yml")
    end
  end



  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end

# linked_filesで使用するファイルをアップロードするタスクは、
# deployが行われる前に実行する必要がある
before 'deploy:starting', 'deploy:upload'
# Capistrano 3.1.0 からデフォルトで deploy:restart タスクが呼ばれなくなったので、
# ここに以下の1行を書く必要がある
after 'deploy:publishing', 'deploy:restart'
