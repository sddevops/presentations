#lang slideshow

(require slideshow/text)

(define (lesson-t text)
  (big
   (bt text)))

(slide
 (big (bt "Shard Your Shelf: Reliably"))
 (big (bt "monitoring of apps in near real-time"))
 (small (t "San Diego DevOps Meetup, May 17, 2017"))
 (t "Andrew Gwozdziewycz, Heroku, @apgwoz"))

(slide
 (big (big (big (big (t "Hi.")))))
 (comment "Hi, I'm Andrew Gwozdziewycz. I lead the team that builds the
\"operational experience\" at Heroku."))

(slide
 (big (big (t "???")))
 (comment "There's a few questions you might already be asking."))

(slide
 (t "Guh-shev-itz from \"Gwozdziewycz?\"")
 (comment "Yeah... It's Polish, doesn't look like it sounds, and has letters that it shouldn't."))

(slide (big (big (big (big (t "¯\\_(ツ)_/¯"))))))

(slide
 (t "Operational Experience?")
 (comment #<<EOL
Operational Experience?

We're charged to provide some basic observability via metrics, alerting,
and some naive container auto scaling for web applications. We're
not trying to be everything to everyone. Instead we're trying to
provide a basic level of operational insight without you having to
lift a finger. As much as possible, we treat your app like a black
box.

EOL
))

(slide
 (t "Heroku?")
 (comment #<<EOL

Heroku?

Heroku coined the term `git push heroku master`. Our founders started
the company to make it trivial to deploy and run Ruby on Rails
applications. No provisioning instances. No setting up Apache with
mod_ruby or Passenger, none of that. You focus on developing your app.

Since the early days, Heroku has expanded to be able to run just about
any other web application you've got, provided it will run in Docker,
or straight up on Ubuntu within lxc containers.... That basically means
anything, even a bunch of .NET apps, though it's not really supported.
EOL
))


(slide
 (t "\"So you wanna build a monitoring system?\"")
 (comment #<<EOL
This talk was originally titled "So you wanna build a monitoring
system?" and was basically going to talk about all the decisions one
has to make to do that. The content is pretty much still exactly the
same. Though, I'm focusing a bit more on lessons I've learned from
building our own monitoring system, not presenting a choose your own
adventure game.
EOL
))


(slide
 (t "MetaaS: Metrics as a Service")
 (comment #<<EOL
MetaaS is the name of the monitoring system my team runs for our
customers. All of our data is parsed from key value pairs from logs
that other teams at Heroku generate, and we aggregate and turn that
data into summarized metrics at 3 different resolutions 1m, 10m, and
1hr.

The Heroku Data Platform also stores it's metrics data in this
database, allowing them to provide metrics and monitoring to their
customers, important metrics about what's going on with their data
stores, and Kafka clusters.
EOL
))

(slide
 #:title "Metrics as a Service"
 (item "service time histograms")
 (item "throughput (by status)")
 (item "memory usage")
 (item "load average")
 (item "errors")
 (item "restarts, deployments, etc...")
 (comment #<<EOL
Heroku has a pretty unique and interesting advantage in collecting
this data, because we have access to the underlying containers, and
routing infrastructure. The routing infrastructure is basically a
reverse proxy that sends requests appropriately to containers that
speak HTTP. We get service time, throughput, and request related
errors directly from that. And, we get load averages, and memory usage
from the information the CGroups and lxc provide.

As I mentioned before, we try to do this in a black box style, without
any knowledge of the underlying app.
EOL
))


(slide
 (t "Memory related JVM Metrics..")
 (t "with other languages coming soon.")
 (comment #<<EOL
We've started allowing customer's apps to send us metrics, too, but
this is currently limited to interesting metrics like JVM heap usage
and garbage collection times. This offering will be expanded out to
other languages and frameworks in the future.

This requires some intervention from the app owner at the moment.
EOL
))

(slide
 (t "A note about monitoring...")
 (comment #<<EOL
There are pretty much two ways to monitor a computer system. Let your
users do it, and actively do something about it yourself.
EOL
))

(slide
 (t "1. Let your users do it.")
 (comment #<<EOL
This model works pretty well, but results in a lot of user frustration
and lost customers. It basically works by doing nothing until a user
reaches out to you to complain that there's a tire fire burning. Once
you get the heads up, you investigate and go on and fix whatever is
wrong.

This works for a while, but eventually users will tell you with their
feet, which is not great. That leads to the second way.
EOL
))

(slide
 (t "2. Do it yourself.")
 (comment #<<EOL
You don't necessarily have to build out a whole new system, and you
really shouldn't if you can avoid it. Pull something off the shelf:
Librato, Pingdom, Librato AND Pingdom, and set up something like
PagerDuty to notify you when something is wrong.

What to actually monitor with your new found capabilities is a
process, and will change over time. Your users will probably tell you
things, which will result in changes to what you are
monitoring. That's fine! But, try to anticipate the big things, at
least.
EOL
))

(slide
 (lesson-t "Lesson 1: Your reliability")
 (lesson-t "and trustworthiness depends")
 (lesson-t "upon your own monitoring")
 (lesson-t "and operational practices.")
 (comment #<<EOL
Lesson 1: Your reliability and trustworthiness depends upon your own monitoring and operational practices.

If your only monitoring is by letting your users tell you something is
wrong, you don't have a reliable, or trust worthy service. You just
don't.

And, if you're not honest with users when things go wrong, that's
going to lead to user confusion, and further trust issues. Basically,
follow best practices for incident response, and triage events
honestly.

There's a reason this is Lesson 1. If you're building a monitoring
system, it's the way in which *other* people *implement*
monitoring. If it's unreliable, the whole chain of trust is inherently
broken.

*As a monitoring provider, maintaining a relationship of trust is
the top priority! Be honest with, and trust your users.*
EOL
))

(slide
 (t "Heroku Operations / SRE")

 (comment #<<EOL
For us, we've built upon Heroku's operational best practices. We have
the standard oncall rotation, playbooks, loads of metrics, and
*actionable* alerts.

I'm not going to say much more about this, except to *stress* that
building a monitoring system requires extra discipline since others
will rely on you to tell them that their tires are on fire.

The other thing I'll say is that while my team does monitor some apps
with our own monitoring system, we don't rely exclusively on
it. That'd be crazy. You need some hybrid approach with 3rd party, and
your own.

EOL
))

(slide
 (t "Ingestion of events")
 (comment #<<EOL
An important thing to consider is how do you get data into your
system, and what kind of data are you collecting anyway? For the
purposes of monitoring web applications, which is our primary concern,
the two most important things are probably response times and the
volume of HTTP status codes.
EOL
))

(slide
 (lesson-t "Lesson 2: IATUS: It's about")
 (lesson-t "the user, stupid!")
 (comment "It's about the user. It's always about the user."))

(slide
 (t "Memory, Load Averages, Deployments, Scale changes...")
 (comment #<<EOL
All the other data you collect should assist you in understanding the
symptoms your users are seeing. Does the load average increase with
more requests? Is there more memory pressure at high request volumes?
Did you just deploy and things went south?

This type of information leads to better understanding of the symptoms
you're alerting on, and *might* lead you to understanding the cause.
EOL
))

(slide
 (t "Memory, Load Averages, Deployments, Scale changes...")
 (item "Rob Ewashuk's \"My Philosophy on Alerting\"")
 (comment #<<EOL
Your disk is at 95% capacity, but unless users are actually affected
by it, so what? There's a ton of literature about what to alert on...
I recommend Rob Ewaschuk's "My Philosophy on Alerting" to start with.
EOL
))

(slide
 (t "How do these events flow into our system?")
 (comment #<<EOL
How do these events flow into our system?
EOL
))


(slide
 (t "Logs as data.")
 (comment #<<EOL
Logs as data.

We use log events, augmented with key value pairs that give us
measurements about process memory usage, load, and requests that give
us latency and status codes. Additionally, we'll parse Heroku generated
logs that provide information about restarts and scaling, deployments,
etc.

Heroku ships a lot of metrics in logs, which has a lot of benefits,
but it's not without its problems, too. For one...
EOL
))


(slide
 (t "Logs are lossy... by design.")
 (comment #<<EOL
Log loss results in gaps in visibility. We monitor log loss as much as
we can and treat it seriously, opening an incident if there's
sustained loss for some period of time. Our customers need to know if
we're not able to accurately alert them, or show them what they
need to know right now.

Fortunately, lossy logs still maintain the property that matters. They
are *current*. Dropped logs might be an inconvenience, and might lead
to false positive alerts, but it's not a death sentence.
EOL
))

(slide
 (lesson-t "Lesson 3: Hold on to what")
 (lesson-t "you've got.")
 (comment #<<EOL
It's important to keep the data you *do* receive, though. Any and all
information that can be used to provide insight into what an application
is doing can lead to faster incident remediations, which is *always*
the goal.
EOL
))

(slide
 (t "History: Logs to InfluxDB")
 (comment #<<EOL
History: Logs to InfluxDB

Our original ingestion setup was logs to InfluxDB. From an architecture
standpoint, this was stupidly simple, which is usually good, but this led
to multiple places where data could simply be dropped on the floor.

EOL
))

(slide
 #:title "History: Logs to InfluxDB"
 (item "Logger -> Proxy")
 (item "Proxy -> InfluxDB")
 (item "InfluxDB ... due to operator error")
 (comment #<<EOL

If a proxy server goes down, the logger won't retry forever, and so we
lose them. Likewise, if the proxy can't reach InfluxDB, or it gets
restarted, they'd never make it to InfluxDB.

Lastly, InfluxDB was very new 3 years ago, and we had no idea how to
operate it effectively, nor did we have the time to learn. Naturally,
this lead to a few times where we blew a lot of data away, possibly
unnecessarily.

This is not a great situation to be in.
EOL
))

(slide
 #:title "Kafka is Magic"
 (it "Kafka™ is used for building real-time data pipelines")
 (it "and streaming apps. It is is horizontally scalable,")
 (it "fault-tolerant, wicked fast, and runs in production")
 (it "in thousands of companies.")
 (t  "-- http://kafka.apache.org")
 (comment #<<EOL
Kafka Is Magic

We added Kafka into our architecture, and things got way easier.

We still have loss points... Logger to Kafka-Proxy loss is still a
thing, but it's much harder to do, since Kafka's architecture is much
more resilient to node failures. Multiple nodes can fail and the
system will still accept writes. Basically, as long as there is still
a leader, e.g. 1 node, we're good...

EOL
))


(slide
 (t "Kafka is Magic")
 (comment #<<EOL
But, that's not the end of it. Didn't we just trade off incompetently
running InfluxDB for incompetently running Kafka?

EOL
))


(slide
 (t "Kafka as a Service")
 (comment #<<EOL
Nope! Heroku offers Kafka as a Service, and my team is among it's
biggest customers! The team that does this, does this only, and does a
damn fine job of it. Confluent just released it's own Kafka as a
Service, as well. But, let's be honest, if you're big enough to be
building out a monitoring system, it's likely you have the resources
to have a team dedicated to operating Kafka effectively, too.

EOL
))

(slide
 (lesson-t "Lesson 4: Don't run things")
 (lesson-t "you can't give your full")
 (lesson-t "attention to.")
 (comment #<<EOL
Lesson 4: Don't run things you can't give your full attention to.

We have a small team. It doesn't make sense for us to operate Kafka,
or even InfluxDB, even if it fits perfectly with the problem domain.

Heroku wasn't interested in offering InfluxDB as a service, and for
other reasons we choose to migrate away from it. InfluxDB is a great
product and it's getting better and better all the time. Don't
discredit it because we left it behind.

EOL
))

(slide
 (t "InfluxDB -> ???")
 (comment #<<EOL
With InfluxDB, we basically wrote every event to it, and used
InfluxDB's equivalent of Materialized Views to do our aggregations for
us. But, with everything in Kafka, and it's durability guarantees, and
fan out through multiple consumer abilities, we decided that we didn't
really need a traditional time series data store anyway.

We knew exactly what data we needed to deliver, and at what
resolutions.  Pre-aggregation and writing the aggregates to a database
like Postgres was totally on the table, and is exactly what we did.

EOL
))

(slide
 (t "Postgres as a Service")
 (comment #<<EOL
Postgres as a Service

Of course, Heroku does Postgres as a Service, too, so we didn't have
to worry about setting up a set of High Availability Postgres instances. Substitute
RDS, or any other *MANAGED* datastore and you've got the same thing.

Stop running data stores. It's been commoditized, and someone else is
going to likely do it better than you, anyway. That is, unless of
course, it's your job to be good at it.

EOL
))

(slide
 (t "We've got metrics, and Visualizations...")
 (comment #<<EOL
At this point we've got the ability to query data and display
it. Running queries every minute across all apps isn't really a great
idea though for monitoring purposes, though.

One of the reasons we abandoned InfluxDB was just this. It didn't
scale to 10s of thousands of queries per minute to do alerting like we
needed. And, that's kind of a disaster to manage, anyway.

EOL
))

(slide
 (lesson-t "Lesson 5: Kafka is Magic")
 (comment #<<EOL
Lesson 5: Kafka is Magic

Instead, we took advantage of the fact that we basically have the
ability to fan out our 1 minute summaries, which is what we wanted to
allow customers to alert on.

We do this, basically, in the same way we do aggregations, generally.

EOL
))

(slide
 (tt "cat raw-data | aggregate | kafka --to aggregates")
 (comment #<<EOL
The one process, one consumer per purpose model is great. It makes
thinking about stream processing similar to thinking about shell
pipelines.

We have a single program that does aggregation, and well defined rules
for how it does so, based on the underlying data schema. If something
is a counter, aggregating is just summation. If something is more gauge
like, we do sum, count, sum_squares, total, min, max.

If that something is a latency measurement, well, we aggregate HDR
histograms instead.

To aggregate to 10 minutes resolution, we consume the 1 minute resolution,
and write to a 10 minute summary topic. Then, we'll consume the 10 minute
resolution and write to a 1 hour summary topic.

EOL
))


(slide
 (tt "cat aggregates | persist-to-datastore")
 (comment #<<EOL
Basically, the underlying data store doesn't matter, and if we want to
fan out to multiple data stores to evaluate them, we just have to cat
the appropriate aggregates and write a persister.

A little while ago, I said we choose Postgres to write to? Well, we
did, but we eventually outgrew it as other internal teams wanted to
make use of our metrics pipeline. Without too much work, we simply
spun up a few more processes. One set wrote to Postgres, and the other
wrote to Cassandra.

During the transition to Cassandra, our API would read from Cassandra,
but with the flip of a switch, would start reading from Postgres
again. We eventually removed the switch and tore down the postgres
persister, and were migrated without any downtime.

EOL
))


(slide
 (tt "cat aggregates | alert | kafka --to check-results")
 (comment #<<EOL
Our alerting pipeline is just a different set of programs in a
pipeline. Instead of doing aggregations, the alert program filters out
incoming summaries when there are relevant configured alerts and
performs checks on the data. If the data causes a fault, or even if it
doesn't, it produces a check result to another kafka topic.

The check results are read by yet another process that handles
state transitions (e.g. fault -> OK, OK -> fault), notifications, and
all the other things.

EOL
))


(slide
 (lesson-t "Lesson 6: The best thing about")
 (lesson-t "Unix is the philosophy on")
 (lesson-t "composition of small programs via")
 (lesson-t "pipes.")
 (comment #<<EOL
Lesson 6: The best thing about Unix is the philosophy on composition of small programs via pipes.
	  
Adopting this philosophy in our stream processing framework has led to
small, reusable programs that we can easily modify, monitor, audit and
understand. It's led to migration paths that are painless, instead of
excruciatingly painful.

We *literally* swapped out a data store without any incident, and
without anyone noticing.

EOL
))


(slide
 (lesson-t "Lesson 7: Use reliable, trusted,")
 (lesson-t "off the shelf, components")
 (lesson-t "whenever possible.")
 (comment "Lesson 7: Use reliable, trusted, off the shelf, components whenever possible."))


(slide
 #:title "\"Off the shelf\" components"
 (item "Process orchestration (Heroku, Kubernetes, AWS Container Services...")
 (item "Kafka")
 (item "Postgres")
 (item "Redis")
 (item "Operations processes")
 (item "Librato / Pingdom")
 (comment #<<EOL
Off the Shelf Components.
	  
One thing that we don't do is write new components that are complicated
and complex. Additionally, our goal is to *not* duplicate functionality
that someone else can do a better job at providing us.
EOL
))



(slide
 (t "Case in point: Uptime monitoring")
 (comment #<<EOL
We're currently working on a project that'll provide better uptime
monitoring for all paid apps running on Heroku. We plan to partner
with an external provider to do this, because doing it ourselves leads
to a fun bootstrapping problem, and solving unnecessary to solve
complex problems.

If the Heroku platform is down... it's possible that some aspects of
our own monitoring is too. If we build external health check probes on
the Heroku platform, well, what is that really buying us?

EOL
))


(slide
 (t "Down for everybody or just me?")
 (comment #<<EOL
The only advantage I can think of in doing this ourselves is having
control over all aspects of it, but *really*, partnering with someone
else provides additional trust that our service is working. It's a
confirmation thing.

A 3rd party providing an additional check provides some extra
assurance that things aren't quite right. We do this for our *own*
monitoring, we want to do that for yours, too.

EOL
))


(slide
 (lesson-t "Lesson 8: Monitor what your users")
 (lesson-t "are seeing so you see it, too.")
 (comment #<<EOL
Lesson 8: Monitor what your user's are seeing so you see it, too.

For all the functionality we provide, we have functional tests running
every 15 minutes on our production and staging setups. We have canary
apps that knowingly misbehave and trigger alerts and auto scaling.

We alert if auto scaling stops on those apps, or if an alert doesn't
actually produce a notification.

We alert on log loss, elevated error rates, basically. We try to anticipate
all the things a user would / could complain about if something wasn't
working correctly. They'd be right, but we'd rather tell them before
they tell us.

EOL
))


(slide
 #:title "Summary"
 (item "Your reliability and trustworthiness depends upon your own practices")
 (item "It's about the user, stupid!")
 (item "Hold on to what you've got.")
 (item "Don't run things you can't give your full attention to")
 (comment #<<EOL
* Your reliability and trustworthiness depends upon your own practices
* "It's about the user, stupid!"
* Hold on to what you've got.
* Don't run things you can't give your full attention to
EOL
))

(slide
 #:title "Summary"
 (item "Kafka is magic")
 (item "Composition of small programs via pipes, whenver possible")
 (item "Reliable, off the shelf, components whenever possible.")
 (item "Monitor what your user's see so you see it, too.")
 (comment #<<EOL
* Kafka is Magic
* Composition of small programs via pipes.
* Reliable, off the shelf, components whenever possible.
* Monitor what your user's see so you see it, too.
EOL
))

(slide
 (t "Shard your Shelf.")
 (comment #<<EOL
The title of this talk is "Shard Your Shelf." I'm taking some
liberties on the use of the word, "shard". But, what I hope I've
presented is that the way to build out a reliable monitoring system,
or really, any other system, is to take an approach that incorporates
best practices and architectural elements from, existing, "off the
shelf" components, and making more time for yourself, by letting other
people do work for you.

Doing so, at least in my experience so far, has resulted in a much
more reliable system, and a large number of happy users.

EOL
))
