require 'rake'

task :default do
  puts 'Type "rake --tasks" to see a list of tasks you can perform.'
end

namespace :app do
  desc 'Launch the Dart daemon'
  task :start do
    system 'script/daemon start'
  end
  
  desc 'Stop the Dart daemon'
  task :stop do
    system 'script/daemon stop'
  end
  
  desc 'Restart the Dart daemon'
  task :restart do
    system 'script/daemon restart'
  end
  
  desc 'Start Dart, but stay on top'
  task :run do
    system 'script/daemon run'
  end
  
  desc 'Clear Dart\'s PID file'
  task :zap do
    system 'script/daemon zap'
  end
end

namespace :log do
  desc 'Remove all log files'
  task :clear do
    system 'rm -vf tmp/*.log'
  end
end
