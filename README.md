
Install the Gemset for Spn.ee

```
git clone git@github.com:stormasm/spinnakr-spne.git
cd spinnakr-spne
bundle install

Bring up Redis

Certain API calls require that you have RabbitMQ running as well.

**spinnakr-rule-simulator** does NOT require that RabbitMQ is running

Then To bring up Spn.ee run the following command:

```
unicorn -p 4567
```
