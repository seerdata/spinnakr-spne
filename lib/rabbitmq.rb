class RabbitMQ

  require "amqp/extensions/rabbitmq"

  LOG = Logger.new(STDOUT)
  TAG = "[RabbitMQ]"

  @@conn_string = nil

  CONNECTION_SETTINGS = {
    :on_tcp_connection_failure => Proc.new do |settings|
      LOG.error "#{TAG} TCP Connection Failure."
      puts "TCP Connection Failure. Retrying in 10 seconds..."
    end,
    :on_possible_authentication_failure => Proc.new do |settings|
      LOG.error "Authentication failed. Settings are: #{settings.inspect}"
      puts "Authentication failed. Settings are: #{settings.inspect}"
    end
  }

  def self.setup(settings = {})
    if settings
      @@conn_string = "amqp://#{settings['user']}@#{settings['host']}:#{settings['port']}"
    end
  end

  def self.publish_message_trident(message_hash)
    publish_message message_hash, 'test.spnee.trident'
  end

  def self.publish_message_visitor(message_hash)
    publish_message message_hash, 'test.spnee.visitors'
  end

  def self.publish_message_visit(message_hash)
    publish_message message_hash, 'test.spnee.visits'
  end

  def self.publish_test
    time = Time.now.utc
    start = Time.parse("2014-01-23 00:00 UTC")
    if time >= start
      publish_test_fanout_message
      publish_test_direct_message
    end
  end

  def self.publish_test_fanout_message
    message_hash = {}
    message_hash[:created_at] = Time.now
    message_hash[:payload] = "test fanout"
    publish_message message_hash, 'test.spnee.messages.fanout'
  end

  def self.publish_test_direct_message
    message_hash = {}
    message_hash[:created_at] = Time.now
    message_hash[:payload] = "test direct"

    if @@conn_string.nil?
      LOG.debug("#{TAG} Connection String is nil.")
    end
    unless @@conn_string.nil?
      #LOG.debug("#{TAG} Entering #{__method__}...")
      amqp do |connection|
        AMQP::Channel.new(connection) do |channel|
          #LOG.debug("#{TAG} Channel created")
          channel.confirm_select
          channel.on_error { |ch, channel_close| puts "#{TAG}: channel-level exception: #{channel_close.reply_text}" }
          #channel.on_ack   { |basic_ack| puts "#{TAG}: Received basic_ack: multiple = #{basic_ack.multiple}, delivery_tag = #{basic_ack.delivery_tag}" }
          channel.on_nack   { |basic_nack| puts "#{TAG}: Received basic_nack: #{basic_nack.inspect}" }

          exchange = channel.direct("test.spnee.messages.direct", :passive => true)

          #LOG.debug("#{TAG} [request] Sending a message to #{exchange_name}...")
          exchange.publish(message_hash.to_json,
                        :mandatory => true,
                        :persistent => true,
                        :timestamp => Time.now.utc.to_i,
                        :routing_key => "messages.test.direct")
          channel.close
        end
      end
    end
  end
  # Push a message to a RabbitMQ exchange.
  # Message should be a hash so it can be converted to JSON.
  # Exchange name is also declared in method call.
  def self.publish_message(message_hash, exchange_name)
    if @@conn_string.nil?
      LOG.debug("#{TAG} Connection String is nil.")
    end
    unless @@conn_string.nil?
      #LOG.debug("#{TAG} Entering #{__method__}...")
      amqp do |connection|
        AMQP::Channel.new(connection) do |channel|
          #LOG.debug("#{TAG} Channel created")
          channel.confirm_select
          channel.on_error { |ch, channel_close| puts "#{TAG}: channel-level exception: #{channel_close.reply_text}" }
          #channel.on_ack   { |basic_ack| puts "#{TAG}: Received basic_ack: multiple = #{basic_ack.multiple}, delivery_tag = #{basic_ack.delivery_tag}" }
          channel.on_nack   { |basic_nack| puts "#{TAG}: Received basic_nack: #{basic_nack.inspect}" }
          #publisher_index = channel.publisher_index
          #time = Time.now.utc.strftime('%Y-%m-%d-%H-%M')
          #if publisher_index % 1000 == 0
          #  puts "[#{TAG} - #{time}]: publisher_index = #{publisher_index.to_s}"
          #end
          # Exchange is a "fanout", meaning all queues bound to it
          # will have the message pushed to them. Passive tells the server
          # not to create a new exchange if it already exists.
          exchange = channel.fanout(exchange_name, :passive => true)
          #LOG.debug("#{TAG} [request] Sending a message to #{exchange_name}...")
          exchange.publish(message_hash.to_json,
                        :mandatory => true,
                        :persistent => true,
                        :timestamp => Time.now.to_i)
          channel.close
        end
      end
    end
  end

  #Example exchange_name => "test.spnee.visitors"
  #Example queue_name => "test.visitors.postgres"
  def self.consume_visitor(exchange_name, queue_name)
    #LOG.debug("#{TAG} Entering #{__method__}...")
    amqp do |connection|
      channel = AMQP::Channel.new(connection)
      #LOG.debug("#{TAG} Channel created")
      exchange = channel.fanout(exchange_name)
      # This is a durable queue, it won't be destroyed if the queue empties.
      queue = channel.queue(queue_name, :durable => true).bind(exchange)
      #LOG.debug("#{TAG} #{queue.name} is ready to go.")
      queue.subscribe do |metadata, payload|
        visitor_hash = JSON.parse(payload)
        visitor = Visitor.new()
        visitor.visitor_id = visitor_hash["visitor_id"]
        visitor.account_id = visitor_hash["account_id"]
        visitor.created_at = visitor_hash["created_at"]
        visitor.updated_at = visitor_hash["updated_at"]
        visitor.save
      end
    end
  end

  protected

  def self.amqp(&block)
      #LOG.debug("#{TAG} Entering #{__method__}...")
      # On the next turn of the EM reactor...
      EventMachine.next_tick do
        #LOG.debug("#{TAG} Testing connection...")
        # Check to see if an existing connection exists.
        if AMQP.connection && AMQP.connection.connected?
          #LOG.debug("#{TAG} Already Connected")
          yield(AMQP.connection)
        else
          #LOG.debug("#{TAG} Connecting to: #{@@conn_string}")
          AMQP.connect(@@conn_string, CONNECTION_SETTINGS) do |connection|
            AMQP.connection = connection
            AMQP.connection.on_tcp_connection_loss do |connection, settings|
              # reconnect in 5 seconds, without enforcement
              connection.reconnect(false, 5)
            end
            AMQP.connection.on_possible_authentication_failure do |connection, settings|
              connection.reconnect(false, 5)
            end
            #LOG.debug("#{TAG} Connected")
            yield(AMQP.connection)
          end
        end
      end
  end

end
