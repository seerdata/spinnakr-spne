require "bunny"

connection = Bunny.new
connection.start

channel = connection.create_channel
q = channel.queue("generic", :durable => true, :auto_delete => false)

q.subscribe do |delivery_info, properties, payload|
  puts "[consumer] #{q.name} received a message: #{payload}"
end

sleep 3.5
puts "Disconnecting..."
connection.close
