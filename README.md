Server part of the user interface for the AstroExplorer.
Written in nodejs.

This part knows nothing about redis and the user saving stuff, but will be retooled
to use redis as a cache. newmyads can be plugged in here or used standalone for other things.

Requires:
connect
connect-redis
hiredis
mime
mustache
redis
qs

Requires node > 0.4.8, Redis > 2.2.11, and a working solr connection.

Configs currently in config.coffee
