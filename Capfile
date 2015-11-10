# [必須] Capistranoの設定を読み込む。おまじない
require 'capistrano/setup'

# [必須] デプロイフレームワークを読み込み。
require 'capistrano/deploy'

# rbenvを使用している場合
require 'capistrano/rbenv'

require 'capistrano/rails'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'

require 'capistrano/bundler'
require 'capistrano3/unicorn' # unicornを使っている場合のみ
require 'whenever/capistrano' # wheneverを使っている場合のみ


# [必須] `lib/capistrano/tasks' に定義されたタスクを読み込む
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
