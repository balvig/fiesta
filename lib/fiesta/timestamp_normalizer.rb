require "attr_extras/explicit"

module Fiesta
  class TimestampNormalizer
    extend AttrExtras.mixin
    pattr_initialize :timestamp

    def run
      if timestamp.is_a?(Time)
        timestamp
      else
        Time.parse(timestamp.to_s + "Z")
      end
    end
  end
end
