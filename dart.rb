#!/usr/bin/env ruby

%w(rubygems summer).each { |lib| require lib }

@config = HashWithIndifferentAccess.new(YAML::load_file(File.dirname($0) + '/config/summer.yml'))

module Dart
  class Bot < Summer::Connection
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

            case action[:type]
          
            when 'shell', 'terminal', 'term':
              output = `#{action[:command].dartify {}}`
              privmsg output, source unless action[:silent] or output.nil? or output =~ /^\s*$/
          
            when 'message':
              privmsg action[:message].dartify {}, action[:to] || source
          
            when 'notice':
              response "NOTICE #{action[:to].dartify {} || source} :#{action[:message].dartify {}}"
          
            when 'quit', 'exit':
              Thread.main.exit
          
            end
          end # config[:actions].each
        end # @config[:commands].each_pair
      end # Thread.new
    end # handle_message
  end
end

Dir.glob('lib/**/*.rb') { |lib| require lib }
Dart::Bot.new(@config[:server])
