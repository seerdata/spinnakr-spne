The uuids in this file should

https://github.com/stormasm/customer-generic-simulator/blob/master/lib/msgbase.rb

match up with the uuids in this file

https://github.com/stormasm/spinnakr-spne/blob/master/test/gentoken.rb

By running gentoken.rb you set up redis to have the uuid's populated
in redis **DB 10** and redis **DB 11**

Then when you start publishing out events from here

https://github.com/stormasm/customer-generic-simulator/tree/master/lib

with this command in the customer-generic-simulator

```
ruby sim.rb
```

This puts JSON messages on the Rabbitmq queue called **customer**.

Then one brings up Spn.ee

Then you can run in the test directory in Spn.ee

```
ruby restcustomer.rb
```

Going back to the window that you brought Spn.ee up in you will see
the original token message that you originally sent out above simulating
the data the customer sent out being transformed into what Justin wants
to see on the internal Spinnakr network.

In other words the token gets transformed into the new JSON

```
{"account"=>"1", "project"=>"2", "dbnumber"=>"100", "dimension"=>"visit-useragent",
"key"=>"chrome", "value"=>3, "created_at"=>"2014-09-25 12:06:24 -0700",
"interval"=>["weeks"], "calculation"=>["sum", "average", "percentage"]}
```
In this case the message gets taken off the **customer** queue, transformed,
and then placed on the **generic** queue.  Justin now takes over and does
the storm processing...

If you want to look at the data placed on the **generic** queue instead of
looking in the Spn.ee console you can run this

```
ruby stormqueue.rb
```

So in summary this is the order.

```
ruby sim.rb
unicorn -p 4567
ruby restcustomer.rb
ruby stormqueue.rb
```
