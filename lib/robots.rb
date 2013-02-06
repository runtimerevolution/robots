module Robots
  VERSION = "0.1"
end

require 'robots/dsl'
require 'robots/template_handler'
require 'robots/railtie' if defined?(Rails)
