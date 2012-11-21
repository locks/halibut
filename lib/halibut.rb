require "halibut/version"

# Halibut is the main namespace
module Halibut
  autoload :Builder, 'halibut/builder'

  autoload :RelationMap, 'halibut/relation_map'
end

# The Adapter namespace contains classes that aid in the
# mapping of HAL Resources into a specific format.
module Halibut::Adapter
  autoload :JSON, 'halibut/adapter/json'
end

# Halibut::HAL contains the domain objects that reflect the HAL specs.
module Halibut::HAL
  autoload :Link, 'halibut/hal/link'
  autoload :Resource, 'halibut/hal/resource'
end