require 'spec_helper'

def accepts_filter(name, options = {}, &block)
  metadata[:filter_parameters] = options.merge name: name, block: block
end