#!/usr/bin/env ruby
%w(rubygems summer).each { |lib| require lib }

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
          
          eval @config[:commands][command]['do'] if @config[:commands].key?(command)
        end
      end
    end # handle_message
  end
end

config = HashWithIndifferentAccess.new(YAML::load_file(File.dirname($0) + '/config/summer.yml'))
Dart::Bot.new(config[:server])
