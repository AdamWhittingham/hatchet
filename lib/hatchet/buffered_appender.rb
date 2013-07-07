# -*- encoding: utf-8 -*-

module Hatchet

  class BufferedAppender
    extend Forwardable

    def_delegators :@appender, :enabled?, :formatter, :formatter=, :levels, :levels=, :clear_levels_cache!

    def initialize(appender)
      @buffer_name = "hatchet_appender_buffer_#{appender.object_id}"
      @appender = appender
    end

    def add(level, context, message)
      buffer << message
      nil
    end

    def buffer
      Thread.current[@buffer_name] ||= []
    end

    def flush!
      buffer.slice!(0, buffer.size).each do |message|
        @appender.add(message.level, message.context, message)
      end
    end

  end

end

