
# Spinnakr Generic Event System

Based on experience to date with our Spinnakr web site and back end
infrastructure, we are launching a new platform that will allow our customers
to more easily customize their data and pass it through our analytics system.

In the past, our systems analyzed our customer's data that was generated
from their web sites exclusively.  Visitors to our customer's web sites produced
data based on the core features of the web browser.  We
were only able to process and analyze data that the browser knew about.

Our new system that is currently in development will allow our customers to
analyze any type of data in their business.  We are no longer tied to the
web browser as our only source of analytics data. Going forward one can
identify an analytics problem, and then pump data into our system for
results.

The beauty of our system is that we took all of the knowledge and know how
from our first product and are using that same infrastructure and intellectual
property to build out a very cool new system that is much more generic and
adaptable.

## Generic Events

The whole basis for our system is generic events.  These events are encapsulated
in a JSON data structure.  In a certain way, our system can be thought about in
a similar fashion to a stream processing system. Data streams of events are
tied together via pipelines where each connection does a certain task. The ability
to modularize the system is enabled via an interchangeable data format at each step.

The generic data structure has a small set of core components:

* dimension
* key
* value
* time stamp
* time interval
* algorithms

#### Dimension

The dimension can be thought of as the high level concept of detail that
the processor should act on.  It can also be viewed as describing a set
of data where each component of that set is delineated via its key. In
computer science terms, the dimension is a description of a hash map.
In database terms, the dimension is the name of a table.

#### Key Value

The key value is a pair.  They are tightly coupled together.  However,
the information you can store in these two fields can be anything.
Usually, the information will be some sort of a data point, but it doesn't
have to be.  The key value pairs can be time ordered, or not.

#### Timestamp

This is a basic time data structure

```
"created_at": "2014-08-06 17:51:10 +0000"
```

#### Time Interval

Any unit of time is suitable here including:

```
seconds, minutes, hours, days, weeks, months, years
```

#### Algorithms

Initially these algorithms will be mathematical in nature, but they don't
have to be.  For starters we will be rolling out simple functions including:

```
count, sum, average, standard_deviation, linear_regression
```

## Communication

Spinnakr will define API end points that allow our customers to get data into
our system and retrieve answers after we have done data analysis and recognized
significant events.

#### Data Input

The data coming into our systems will be the generic events outlined above.  Each
event can be tied to the customers internal application that turns around and
makes a REST request or publishes out an event to RabbitMQ.

#### Data Output

Our systems will take the above data as input and analyze the data in real time
looking for significant trends that warrant a response to the data input.
When something happens we will write out the event to our persistance system.
Our customers will then have the ability at any point in time to make a request
into our system to get the results.  At the lowest level, these results will
be distributed in a similar fashion to the data input system via REST calls.
However, eventually our customers or we can design web based systems that display
the results, events, or recommendations similar to our current Spinnakr web site.

### REST or RabbitMQ
All communication with our event system will be via client side programs written
in the customer's programming language of choice or publishing events to
RabbitMQ.

#### REST clients

Because our system is REST based, our customers can communicate with our system
using any programming language.  Initially we will provide a
[Ruby REST Client](https://github.com/rest-client/rest-client)
that the customer can use as a model to communicate with Spinnakr.  But eventually
we will provide clients in all of the popular programming languages including

```
Go, Java, Javascript, Python
```

#### RabbitMQ clients

If its easier for our customer to simply pump out events to a RabbitMQ
system, then we will turn around and process those events into our system.
Rabbit enables one to use these
[programming languages]
(http://www.rabbitmq.com/devtools.html)
to communicate with it from inside any application.

### Authentication

All REST
calls will be authenticated via a token.  The token will initially be obtained
by our customer going to a designated website where they will sign in and obtain
a token.  This token will be project based, meaning that each customer could
have multiple projects where different types of data and events are processed
and generated.  By tying a token to a project, it enables the customer to
have multiple projects going on at the same time, and they don't have to worry
about associating different data sets to project numbers.  They will simply have their token
sitting inside their code base for a particular project.

Each time the customer makes a REST call to our system, they will pass along the
token inside of the request.


### Core Technologies

* [JSON](http://json.org/)
* [RabbitMQ](http://www.rabbitmq.com/)
* [Redis](http://redis.io/)
* [REST](http://en.wikipedia.org/wiki/Representational_state_transfer)
* [Sinatra](http://www.sinatrarb.com/documentation.html)
* [Storm](http://storm.incubator.apache.org/)
