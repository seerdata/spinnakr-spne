The
[uuids]
(http://en.wikipedia.org/wiki/Universally_unique_identifier)
or
[SecureRandoms]
(http://ruby-doc.org/stdlib-2.1.2/libdoc/securerandom/rdoc/SecureRandom.html)
in this file

https://github.com/stormasm/customer-generic-simulator/blob/master/lib/msgbase.rb

should match up with the uuids in this file

https://github.com/stormasm/spinnakr-spne/blob/master/test/gentoken.rb

Remember that with Justin's current setup:

```
export RACK_ENV=development
```

This took me awhile to figure out as it was **production** and messages
were not being published because of the
config file **spneg/config/development.config.yml**

By running

```
ruby gentoken.rb
```

you set up redis to have the uuid's populated
in redis **DB 10** and redis **DB 11**

Then when you start publishing out events from here

https://github.com/stormasm/customer-generic-simulator/tree/master/lib

with this command in the customer-generic-simulator

```
ruby sim.rb -m job-skills
```

This puts JSON messages on the RabbitMQ queue called **customer**.

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
{"account_id"=>1, "project_id"=>2, "dbnumber"=>100, "dimension"=>"visit-useragent",
"key"=>"chrome", "value"=>3, "created_at"=>"2014-09-25 12:06:24 -0700",
"interval"=>["weeks"], "calculation"=>["sum", "average", "percentage"]}
```
In this case the message gets taken off the **customer** queue, transformed,
and then placed on the **generic** exchange.  Justin now takes over and does
the storm processing...

If you want to look at the data placed on the **messages** queue instead of
looking in the Spn.ee console you can run this

```
ruby stormqueue.rb
```

So in summary this is the order.

```
ruby sim.rb -m job-skills
unicorn -p 4567
ruby restcustomer.rb
```

Now that the event data from storm got put into redis DB 100 or DB 101,
you can grab the data off of redis with this command.

```
ruby event01.rb
```

And when storm is not running you can see the data here.
```
ruby stormqueue.rb
```
