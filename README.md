# Anti Fraud Detect

## Getting Started

1. You must have the following dependencies installed:

     - Ruby 3
          - See [`.ruby-version`](.ruby-version) for the specific version.
     - Node 16 
          - See [`.nvmrc`](.nvmrc) for the specific version.
     - PostgreSQL 13
     - Redis 6.2
     - [Chrome](https://www.google.com/search?q=chrome) (for headless browser tests)

    If you don't have these installed, you can use [rails.new](https://rails.new) to help with the process.

2. Run the `bin/setup` script.
3. Run the `rails anti_fraud:update_score_anti_fraud` script.
4. Run the `rails anti_fraud:update_model_anti_fraud` script.
5. Run the `rails anti_fraud:update_model_anti_fraud` script.
6. Start the application with `rspec`
7. Visit http://localhost:3000

## Code

     # Service
     app/services/anti_fraud_service.rb

## Testing application

1. Visit http://anti-fraud-detect.146.190.169.253.sslip.io/anti_frauds

2. If you need more information about the acquirer market, visit: http://anti-fraud-detect.146.190.169.253.sslip.io/faqs

3. Check all processing on-line: http://anti-fraud-detect.146.190.169.253.sslip.io/transactions

## Deploy Dokku
     
     # Server
     ssh root@your.server.ip.address

     cat ~/.ssh/authorized_keys | dokku ssh-keys:add admin

     dokku domains:set-global your.server.ip.address
     dokku domains:set-global your.server.ip.address.sslip.io

     sudo dokku plugin:install https://github.com/dokku/dokku-postgres.git
     sudo dokku plugin:install https://github.com/dokku/dokku-redis.git
     sudo dokku plugin:install https://github.com/dokku/dokku-letsencrypt.git
     sudo dokku plugin:install https://github.com/dokku/dokku-redirect.git
     sudo dokku plugin:install https://github.com/dokku/dokku-maintenance.git maintenance
     sudo dokku plugin:install https://github.com/dokku-community/dokku-apt apt

     dokku apps:create anti-fraud-detect
     dokku postgres:create anti-fraud-detect-postgres
     dokku postgres:link anti-fraud-detect-postgres anti-fraud-detect
     dokku redis:create anti-fraud-detect-redis
     dokku redis:link anti-fraud-detect-redis anti-fraud-detect
     dokku storage:ensure-directory anti-fraud-detect
     dokku proxy:ports-set anti-fraud-detect http:80:3000

     # Storage

     dokku storage:mount anti-fraud-detect /var/lib/dokku/data/storage/anti-fraud-detect/storage:/rails/storage
     dokku storage:mount anti-fraud-detect /var/lib/dokku/data/storage/anti-fraud-detect/db/model:/rails/db/model

     dokku storage:unmount anti-fraud-detect /var/lib/dokku/data/storage/anti-fraud-detect/storage:/rails/storage
     dokku storage:unmount anti-fraud-detect /var/lib/dokku/data/storage/anti-fraud-detect/db/model:/rails/db/model

     # Local
     git remote add production dokku@your.server.ip.address:anti-fraud-detect
     dokku --remote production git:set deploy-branch main
     dokku --remote production config:set RAILS_ENV=production RAILS_MASTER_KEY=`cat config/credentials/production.key`

     git push production main

     # Operations
     dokku --remote production ps:report anti-fraud-detect
     dokku --remote production storage:list
     dokku --remote production ps:scale web=1 worker=1
     dokku --remote production logs anti-fraud-detect -t
     dokku --remote production ps:stop
     dokku --remote production ps:start
     dokku --remote production ps:restart
     dokku --remote production run bundle exec rails c
