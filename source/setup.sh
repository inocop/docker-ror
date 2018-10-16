#!/usr/bin/env bash


echo -e "\nReset DB!"
read -p "tartget? [dev/production]: " answer

if   [ "$answer" = "dev" ]; then
  RAILS_ENV=development
elif [ "$answer" = "production" ]; then
  RAILS_ENV=production
else
  echo "Interruption"
  exit
fi


set -eux

RAILS_APP_DIR=/var/www/app/rails_app
NODE_APP_DIR=/var/www/app/node_app
cd ${RAILS_APP_DIR}


###########################
#  create project         #
###########################
# gem install rails -v '5.1.6'
# rails _5.1.6_ new . --database=mysql --skip-bundle --skip-coffee --skip-turbolinks --skip-sprockets

###########################
#  change file            #
###########################
# edit config/database.yml
#        use myconf.yml
#
# edit config/secrets.yml
#        use myconf.yml
#
# edit config/application.rb
#        use myconf.yml

bundle config --local build.nokogiri --use-system-libraries
bundle install --path vendor/bundle

bundle exec rake db:create          RAILS_ENV=${RAILS_ENV}
bundle exec rake db:schema:load     RAILS_ENV=${RAILS_ENV} # or bundle exec rake db:migrate
bundle exec rake db:seed            RAILS_ENV=${RAILS_ENV}
bundle exec rake db:environment:set RAILS_ENV=${RAILS_ENV}

bundle exec rake db:create          RAILS_ENV=test
bundle exec rake db:environment:set RAILS_ENV=test


cd ${RAILS_APP_DIR}/public
npm install

cd ${NODE_APP_DIR}
npm install

# passenger
passenger-config restart-app /var/www/app/rails_app


# puma
# $ cd ${APP_DIR}
# $ bundle exec rails s -b 0.0.0.0 -p 8888