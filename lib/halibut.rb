require "halibut/version"

# Halibut is the main namespace
module Halibut
  autoload :Builder,  'halibut/builder'
  autoload :Document, 'halibut/document'
end

# The Adapter namespace contains classes that aid in the
# mapping of HAL Resources into a specific format.
module Halibut::Adapter
  autoload :JSON, 'halibut/adapter/json'
  autoload :XML,  'halibut/adapter/xml'
end

# Halibut::Core contains the domain objects that reflect the HAL specs.
module Halibut::Core
  autoload :Resource, 'halibut/core/resource'
end
