require "halibut/version"

# Halibut is the main namespace
module Halibut
  autoload :Builder, 'halibut/builder'
end

# The Adapter namespace contains classes that aid in the
# mapping of HAL Resources into a specific format.
module Halibut::Adapter
  autoload :JSON, 'halibut/adapter/json'
end

# Halibut::HAL contains the domain objects that reflect the HAL specs.
module Halibut::HAL
  autoload :Resource, 'halibut/hal/resource'
end