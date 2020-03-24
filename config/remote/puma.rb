# puma configuration

threads 0, 16
workers %x(grep -c processor /proc/cpuinfo)

preload_app!

root_dir = Dir.pwd

environment "production"
daemonize false
pidfile File.join(root_dir, "tmp", "pids", "puma.pid")
state_path File.join(root_dir, "tmp", "pids", "puma.state")
# bind "tcp://0.0.0.0:3000"
shared_dir = root_dir.gsub(/releases\/\d{14}/,"shared")
bind "unix://#{shared_dir}/tmp/sockets/puma.sock"
