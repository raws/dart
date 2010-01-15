require 'rubygems'
require 'summer'

module Dart
  class Bot < Summer::Connection
    def initialize
      @ready = false
      @started = false
      
      load_config
      
      @server = @config[:server]
      @port = (@config[:port] || 6667).to_i
      
      connect!
      
      loop do
        startup! if @ready && !@started
        parse(@connection.gets)
      end
    end
    
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
          
          if @config[:commands].key?(command)
            settings = @config[:commands][command]
            eval settings['do']
          end
        end
      end
    end
    
    private
    
    def load_config
      @config = HashWithIndifferentAccess.new(YAML::load_file("#{DART_ROOT}/config/dart.yml"))
    end
    
  end
  
end
