class Tools
  def self.retryable(options = {})
    opts = { tries: 3, on: Exception }.merge(options)
    retry_exception, retries = opts[:on], opts[:tries]

    begin
      return yield
    rescue retry_exception => e
      if (retries -= 1) >= 0
        puts "#{e.inspect}. Retry index #{retries}"
        retry
      end
    end
  end
end
