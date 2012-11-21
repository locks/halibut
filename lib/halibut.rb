require "halibut/version"

# Halibut is the main namespace
module Halibut
  autoload :Builder, 'halibut/builder'
end

# Halibut::HAL contains the domain objects that reflect the HAL specs
module Halibut::HAL
  autoload :Resource, 'halibut/hal/resource'
end