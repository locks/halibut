require "halibut/version"

# Halibut is the main namespace
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
