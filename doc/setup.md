

####To bring up Spn.ee

unicorn -p 4567

####Testing Scenarios

1. Turn on RabbitMq
2. Turn on Redis

####Non Legacy Testing

The following file that interacts with redis has to be switched to localhost

lib/redis/rediswarden

There are test files located in lib/redis/test

**rest01.rb** should run out of the box

**warden01.rb** needs some setup prior to running

You need to get an authenticated token into redis first.

You do this by commenting out the test code at the end of /lib/redis/rediswarden

Then you run that file

ruby rediswarden

That will create a token in the output that you can then copy and paste into
the file **warden01.rb**

####Legacy Testing

**/lib/spnee_log.rb** the redis config has to be switched to localhost

Turn on the database

####development.config.yml

```
database: postgres://ma@localhost/spinnakr_development

or

database: postgres://ubuntu@localhost/spinnakr_development

rabbitmq:
  host: localhost
  port: 5672
  user: guest

local_cache:
  redis:
    host: localhost
  expiration_days: 7
```
