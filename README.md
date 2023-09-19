# cache_guard

*cache_guard* allows you to protect the execution of a block against concurrency.

## Description

*cache_guard* makes use of your application [cache store][cache_stores] to ensure that there is no parallel execution
of a given block of code. You can think of *cache_guard* as a simple distributed *mutex* that instead of blocking
raises an error.

The best use case for *cache_guard* is granting synchronous access to a shared resource on asynchronous calls.
For instance, you can use with the [delayed_job gem][delayed_gem] to ensure that only one *worker* is accessing the
shared resource and then rely on the *delayed_job* retries mechanism to execute the other *workers*.

## Installation
This gem is available on RubyGems:

[https://rubygems.org/gems/cache_guard](https://rubygems.org/gems/cache_guard)

## Usage
To use simply call the *guard* method passing a string that represents the shared resource and optionally a hash
with options.

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
cache_guard = CacheGuard.new("resource bar", { :expires_in => 180 })
cache_guard.guard { my_task_using_shared_resource }
```

*CacheGuard* raises a *CacheGuard::AcquireError* error on every failed attempt to acquire the guard on a given
resource name.

### Supported cache stores
*CacheGuard* uses the [increment][cache_store_increment] method from *ActiveSupport::Cache::Store* as a way to ensure
atomic access to the shared resource.
Since not all cache stores support this operation, we recommend that you test using the following code on your
rails console:

```ruby
Rails.cache.increment(SecureRandom.uuid, 1)
# => 1
```

We've successfully tested the following cache stores:
* [Dalli][dalli_store_repository] v2.6.2
* [Redis][redis_store_repository] v4.0.0

You can also use [FileStore][file_store] on your development environment as long as you keep in mind that every call
will gain access to the shared resource.

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

[cache_stores]: http://guides.rubyonrails.org/caching_with_rails.html#cache-stores
[cache_store_increment]: http://api.rubyonrails.org/classes/ActiveSupport/Cache/Store.html#method-i-increment
[delayed_gem]: https://github.com/collectiveidea/delayed_job
[dalli_store_repository]: https://github.com/petergoldstein/dalli
[redis_store_repository]: https://github.com/redis-store/redis-rails
[file_store]: http://api.rubyonrails.org/classes/ActiveSupport/Cache/FileStore.html
[semantic_versioning]: http://semver.org/
