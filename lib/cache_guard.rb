class CacheGuard
  class AcquireError < RuntimeError
  end

  def initialize(name, options = {})
    @name = name
    @default_value = options[:default_value] || 1
    @expires_in = options[:expires_in] || 120
    @cache_store = options[:cache_store] || Rails.cache
  end

  def guard
    raise AcquireError, "Unable to acquire guard for: #{@name}" unless acquire

    begin
      yield
    ensure
      release
    end
  end

  def self.guard(name, options = {}, &block)
    new(name, options).guard(&block)
  end

  private

  def acquire
    # The FileStore increment operation returns nil if the cache key doesn't exist. Since the FileStore strategy
    # should be only used in development environment we can allow all guards to pass.
    # http://api.rubyonrails.org/classes/ActiveSupport/Cache/FileStore.html#method-i-increment
    # http://www.rubydoc.info/github/mperham/dalli/ActiveSupport/Cache/DalliStore#increment-instance_method
    value = @cache_store.increment(@name, @default_value, :expires_in => @expires_in)
    value.nil? || value == @default_value ? true : false
  end

  def release
    @cache_store.delete(@name)
  end
end
