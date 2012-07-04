require "halibut/version"

# Halibut is the main namespace
module Halibut
end

# Where all the good stuff is.
module Halibut::HAL
end

require 'halibut/hal/document'
require 'halibut/hal/resource'
require 'halibut/hal/link'

require 'halibut/json/parser'

require 'halibut/xml/document'