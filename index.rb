#!/home/ubuntu/.rbenv/versions/2.7.5/bin/ruby

APP_HOME = '/home/www/default/html/cgi/sot'.freeze
load "#{APP_HOME}/app.rb"
set :run, false

Rack::Handler::CGI.run Sinatra::Application
