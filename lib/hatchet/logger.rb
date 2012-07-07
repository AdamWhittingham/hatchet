# -*- encoding: utf-8 -*-

module Hatchet

  # Internal: Class that handles logging calls and distributes them to all its
  # appenders.
  #
  # Each logger has 6 methods. Those are, in decreasing order of severity:
  #
  #  * fatal
  #  * error
  #  * warn
  #  * info
  #  * debug
  #  * trace
  #
  # All the methods have the same signature. You can either provide a message as
  # a direct string, or as a block to the method is lazily evaluated (this is
  # the recommended option).
  #
  # Examples
  #
  #   logger.info "Informational message"
  #   logger.info { "Informational message #{potentially_expensive}" }
  #
  # Log messages are sent to each appender where they will be filtered and
  # invoked as configured.
  class Logger

    # Internal: Creates a new logger.
    #
    # host      - The object the logger gains its context from.
    # appenders - The appenders the logger delegates its messages to.
    #
    def initialize(host, appenders)
      @context = context host
      @appenders = appenders
    end

    # Public: Logs a message at the given level.
    #
    # message - An already evaluated message, usually a String (default: nil).
    # block   - An optional block which will provide a message when invoked.
    #
    # One of message or block must be provided. If both are provided then the
    # block is preferred as it is assumed to provide more detail.
    #
    # Returns nothing.
    [:trace, :debug, :info, :warn, :error, :fatal].each do |level|
      define_method level do |message = nil, &block|
        return unless message or block
        add level, Message.new(message, &block)
      end
    end

    private

    # Private: Adds a message to each appender at the specified level.
    #
    # level   - The level of the message. One of, in decreasing order of
    #           severity:
    #
    #             * fatal
    #             * error
    #             * warn
    #             * info
    #             * debug
    #             * trace
    #
    # message - The message that will be logged by an appender when it is
    #           configured to log at the given level or lower.
    #
    # Returns nothing.
    def add(level, message)
      @appenders.each { |appender| appender.add(level, @context, message) }
    end

    # Private: Determines the contextual name of the host object.
    #
    # host - The object hosting this logger.
    #
    # Returns 'main' if this is the initial execution context of Ruby, the name
    # of the module when the host is a module, otherwise the name of the
    # object's class.
    def context(host)
      if host.inspect == 'main'
        'main'
      elsif host.class == Module
        host
      else
        host.class
      end
    end

  end

end

