# The classes for handling the projections
#
# Author::    Pavel Kalian  (mailto:pavel@kalian.cz)
# Copyright:: Copyright (c) 2011 Pavel Kalian
# License::   Distributes under the terms of GPLv2 or later

require "./util.rb"
require "./ellipsoid.rb"

# Class representing the projection
class Projection
  # The ellipsoid used
  attr_accessor :ellipsoid

  # Default initializer  
  def initialize
    @ellipsoid = WGS72.new #Probably the most common, so we use it as default  
  end
  
  # Latitude for the given Y coordinate. Input has to be netered in meters from [0,0]
  def lat_at(y)
    nil
  end
  
  # Longitude for the given X coordinate. Input has to be netered in meters from [0,0]
  def lon_at(x)
    nil
  end
  
  # X coordinate (in meters) for the given longitude
  def x_at(lon)
    nil
  end
  
  # Y coordinate (in meters) for the given latitude
  def y_at(lat)
    nil
  end
end

# Class representing the Mercator projection
class Mercator < Projection
  # X coordinate (in meters) for the given longitude implementation for Mercator projection
  def x_at(lon)
    return ellipsoid.a * lon * Util::DEGREE
  end
  
  # Y coordinate (in meters) for the given latitude implementation for Mercator projection
  def y_at(lat)
    return ellipsoid.a / 2 * Math.log((1 + Math.sin(lat * Util::DEGREE)) / (1 - Math.sin(lat * Util::DEGREE)))
  end
end