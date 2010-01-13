#!/usr/bin/env ruby

%w(rubygems summer).each { |lib| require lib }

config = HashWithIndifferentAccess.new(YAML::load_file(File.dirname($0) + '/config/summer.yml'))

module Dart
  module Actions; end
  
  class Bot < Summer::Connection
    include Dart::Actions
    
    def channel_message(sender, channel, message)
      handle_message(sender, channel, message)
    end
  
    def private_message(sender, bot, message)
      handle_message(sender, sender[:nick], message)
    end
  
    def handle_message(sender, source, message)
      Thread.new(sender, source, message) do
        if @config[:owner]
          return unless /^#{@config[:owner]}$/i =~ "#{sender[:nick]}!#{sender[:hostname]}"
        end

        if message =~ /^\s*#{me}\s*[:,]\s*(.*)$/i
          args = $1.split
          command = args.shift
        else
          return
        end

        @config[:commands].each_pair do |name, config|
          next unless name.casecmp(command) == 0

          config = HashWithIndifferentAccess.new(config)

          config[:actions].each do |action|
            action = HashWithIndifferentAccess.new(action)
            action.each_pair { |key, val| action[key] = val.dartify(sender, args) unless key == 'type' }
            type = (action[:type] + '_action').to_sym
            
            send(type, action, sender, source, args) if respond_to?(type)
          end
        end
      end # Thread.new
    end
  end
end

Dir.glob('lib/**/*.rb') { |lib| require lib }

Dart::Bot.new(config[:server])
