require "halibut/version"

# Halibut is the main namespace, and doesn't actually contain behaviour.
# However, if you require it like so:
#
#     # requires all of Halibut namespace
#     require 'halibut'
#
# then everything under the Halibut module namespace, consisting of
# the adapter and the core link and resource objects.
module Halibut; end

require 'halibut/builder'

# The Adapter namespace contains classes that aid in the
# mapping of HAL Resources into a specific format.
module Halibut::Adapter; end

require 'halibut/adapter/json'
Halibut.extend Halibut::Adapter::JSON::ConvenienceMethods


# Halibut::Core contains the domain objects that reflect the HAL specs.
module Halibut::Core; end

require 'halibut/core/resource'
