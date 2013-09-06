require 'spec_helper'

def existing(key)
  -> { instances.any key }
end

def unknown(key)
  -> { instances.none key }
end

def apply(method_name, options = {})
  proc = options[:to]
  -> { proc.call.send method_name }
end