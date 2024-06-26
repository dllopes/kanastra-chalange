# config/puma.rb

max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

port ENV.fetch("PORT") { 3000 }

environment ENV.fetch("RAILS_ENV") { "development" }

pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }

plugin :tmp_restart

if ENV["RAILS_ENV"] == "production"
  ssl_bind '0.0.0.0', '3001', {
    key: ENV['SSL_KEY_PATH'],
    cert: ENV['SSL_CERT_PATH'],
    verify_mode: 'none'
  }
else
  bind 'tcp://0.0.0.0:3000'
end