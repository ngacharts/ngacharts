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
    @ellipsoid = WGS84.new #Probably the most common, so we use it as default  
  end
  
  # Latitude for the given Y coordinate. Input has to be entered in meters from [0,0]
  def lat_at(x, y)
    nil
  end
  
  # Longitude for the given X coordinate. Input has to be entered in meters from [0,0]
  def lon_at(x, y)
    nil
  end
  
  # X coordinate (in meters) for the given longitude
  def x_at(lat, lon)
    nil
  end
  
  # Y coordinate (in meters) for the given latitude
  def y_at(lat, lon)
    nil
  end
end

# Class representing the Mercator projection
class Mercator < Projection
  # X coordinate (in meters) for the given longitude implementation for Mercator projection
  def x_at(lat, lon)
    return ellipsoid.a * lon * Util::DEGREE
  end
  
  # Y coordinate (in meters) for the given latitude implementation for Mercator projection
  def y_at(lat, lon = 0.0)
    return ellipsoid.a * Math.log((1 + Math.sin(lat * Util::DEGREE)) / Math.cos(lat * Util::DEGREE))
  end
  
  # Latitude for the given Y coordinate. Input has to be entered in meters from [0,0]
  def lat_at(x, y)
    return Math.atan(Math.sinh(y / ellipsoid.a)) * Util::RADIAN
  end
  
  # Longitude for the given coordinates. Input has to be entered in meters from [0,0]
  def lon_at(x, y = 0)
    return x / ellipsoid.a * Util::RADIAN
  end
end

# Class representing the Transverse Mercator projection
class TransverseMercator < Projection
  # X coordinate (in meters) for the given latitude and longitude implementation for Transverse Mercator projection
  def x_at(lat, lon)
    sinLcosP = Math.sin(lon * Util::DEGREE) * Math.cos(lat * Util::DEGREE)
    return ellipsoid.a / 2 * Math.log((1 + sinLcosP) / (1 - sinLcosP))
  end
  
  # Y coordinate (in meters) for the given latitude and longitude implementation for Transverse Mercator projection
  def y_at(lat, lon)
    secL = 1 / Math.cos(lon)
    return ellipsoid.a * Math.atan(secL * Math.tan(lat))
  end
  
  # Latitude for the given coordinates. Input has to be entered in meters from [0,0]
  def lat_at(x, y)
    return Math.atan(1 / Math.cosh(x / ellipsoid.a) * Math.sin(y / ellipsoid.a)) * Util::RADIAN 
  end
  
  # Longitude for the given coordinates. Input has to be entered in meters from [0,0]
  def lon_at(x, y)
    return Math.atan(Math.sinh(x / ellipsoid.a) / Math.cos(y / ellipsoid.a)) * Util::RADIAN
  end
end

# Class representing the Polyconic projection
class Polyconic < Projection
  # X coordinate (in meters) for the given longitude implementation for Polyconic projection
  def x_at(lat, lon, lat0, lon0)
    sinLcosP = Math.sin(lon * Util::DEGREE) * Math.cos(lat * Util::DEGREE)
    return ellipsoid.a / 2 * Math.log((1 + sinLcosP) / (1 - sinLcosP))
  end
  
  # Y coordinate (in meters) for the given latitude implementation for Polyconic projection
  def y_at(lat, lon)
    secL = 1 / Math.cos(lon)
    return ellipsoid.a * Math.atan(secL * Math.tan(lat))
  end
  
  # Latitude for the given coordinates. Input has to be entered in meters from [0,0]
  def lat_at(x, y)
    return Math.atan(1 / Math.cosh(x / ellipsoid.a) * Math.sin(y / ellipsoid.a)) * Util::RADIAN 
  end
  
  # Longitude for the given coordinates. Input has to be entered in meters from [0,0]
  def lon_at(x, y)
    return Math.atan(Math.sinh(x / ellipsoid.a) / Math.cos(y / ellipsoid.a)) * Util::RADIAN
  end
end
