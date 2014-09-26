The uuids in this file should

https://github.com/stormasm/customer-generic-simulator/blob/master/lib/msgbase.rb

match up with the uuids in this file

https://github.com/stormasm/spinnakr-spne/blob/master/test/gentoken.rb

By running gentoken.rb you set up redis to have the uuid's populated
in redis **DB 10** and redis **DB 11**

Then when you start publishing out events from here

https://github.com/stormasm/customer-generic-simulator/tree/master/lib

with this command

```
ruby sim.rb
```
