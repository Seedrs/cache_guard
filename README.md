# cache_guard

*cache_guard* allows you to protect the execution of a block against concurrency.

## Description

*cache_guard* makes use of your application cache store to ensure that there is no parallel execution of a
given block of code. You can think of *cache_guard* as a kind of *mutex* without the *wait* functionality.

The best use case for *cache_guard* is granting synchronous access to a shared resource on asynchronous calls
allowing one to execute and raising errors on others. For instance, you can use with the [delayed_job gem][delayed_gem]
to ensure that only one worker is accessing the shared resource and then rely on the provided retries mechanism
to execute other tasks.

## Installation
*cache_guard* is being used with *ActiveSupport::Cache::Store* 4.1 although it should be compatible with other versions.

This gem is available on RubyGems:

## Usage
To use simply call the *guard* method passing a string that represents the name of the key that will be put in cache
to block other guard calls and optionally an hash with options.

```ruby
CacheGuard.guard("resource foo") { my_task_using_shared_resource }
```

Accepted options:
* *default_value*: The value that will be put in cache. The default value is 1;
* *expires_in*: This value must be greater than the maximum execution time of the block. Please note that after
this time we'll not cancel the previous execution. The default value is 120 (seconds).
* *cache_store*: The *ActiveSupport::Cache::Store* instance that you want to use. By default we'll get this
from *Rails.cache*.

*CacheGuard* can also be instantiated and used as follows.

```ruby
cache_guard = CacheGuard.new("resource bar", :expires_in => 180)
cache_guard.guard { my_task_using_shared_resource }
```

*CacheGuard* raises a *CacheGuard::AcquireError* error on every failed attempt to acquire the guard on a given
 resource name.

### Supported cache stores
Any *ActiveSupport::Cache::Store* should be suitable to use, although we recommend that you check
the documentation and ensure the *increment* operation is atomic. For instance, we're using Memcached, another good
example would be Redis.

## Contributing

Fork this repository and send a pull request.

To execute the test suite locally, use the following commands:

```bash
bundle install
bundle exec rspec
```

## Versioning
This gem uses [Semantic Versioning 2.0.0][semantic_versioning], which means:

> Given a version number MAJOR.MINOR.PATCH, increment the:

> 1. MAJOR version when you make incompatible API changes,

> 2. MINOR version when you add functionality in a backwards-compatible manner, and

> 3. PATCH version when you make backwards-compatible bug fixes.

> Additional labels for pre-release and build metadata are available as extensions to the MAJOR.MINOR.PATCH format.

[delayed_gem]: https://github.com/collectiveidea/delayed_job
[semantic_versioning]: http://semver.org/
