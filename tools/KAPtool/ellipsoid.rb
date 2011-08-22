# The classes for handling the Earth ellispoid
#
# Author::    Pavel Kalian  (mailto:pavel@kalian.cz)
# Copyright:: Copyright (c) 2011 Pavel Kalian
# License::   Distributes under the terms of GPLv2 or later

# This class represents the ellipsoid
class Ellipsoid
  # Equatorial radius (meters)
  attr_accessor :a
  # Polar radius (meters)
  attr_accessor :b
  # Flattening
  attr_accessor :f
  
  # Computes radius in meters at given latitude
  def radius_at_lat(lat)
    l1 = (a**2 * Math.cos(lat * Util::DEGREE))**2 + (b**2 * sin(lat * Util::DEGREE))**2
    l2 = (a * Math.cos(lat * Util::DEGREE))**2 + (b * Math.sin(lat * Util::DEGREE))**2
    return Math.sqrt(l1 / l2)
  end
  
  # The Earth's radius of curvature in the (north-south) meridian at given latitude
  def meridional_radius_at(lat)
    l1 = (a*b)**2
    l2 = ((a * Math.cos(lat * Util::DEGREE))**2 + b * Math.sin(lat * Util::DEGREE)**2)**(3/2)
    return l1 / l2 
  end
  
  # If one point had appeared due east of the other, one finds the approximate curvature in east-west direction.
  # This radius of curvature in the prime vertical, which is perpendicular, or normal, to M at geodetic latitude
  def normal_radius_at(lat)
    l1 = a**2
    l2 = Math.sqlrt((a * Math.cos(lat * Util::DEGREE))**2 + (b * Math.sin(lat * Util::DEGREE))**2)
    return l1 / l2
  end
  
  # The Earth's mean radius of curvature (averaging over all directions) at latitude
  def mean_radius_at(lat)
    return Math.sqrt(meridional_radius_at(lat) * normal_radius_at(lat))
  end
  
  # The Earth's radius of curvature along a course at geodetic bearing (measured clockwise from north) at given latitude
  def course_radius_at(lat, course) 
   return 1 / (Math.cos(course * Util::DEGREE)**2 / meridional_radius_at(lat) + Math.sin(course * Util::DEGREE)**2 / normal_radius_at(lat))
  end
end

# This class represents the sphere with mean radius
class MeanSphere < Ellipsoid
  # Default initializer, sets parameters of the ellipsoid
  def initialize
    @a = 6371009.0
    @b = 6371009.0
    @f = 0.0
  end
end


# This class represents the WGS 84 ellipsoid
class WGS84 < Ellipsoid
  # Default initializer, sets parameters of the ellipsoid
  def initialize
    @a = 6378137.0
    @b = 6356752.3142
    @f = 1/298.257223563
  end
end

# This class represents the WGS 72 ellipsoid
class WGS72 < Ellipsoid
  # Default initializer, sets parameters of the ellipsoid
  def initialize
    @a = 6378135.0
    @b = 6356750.52
    @f = 1/298.26
  end
end

# This class represents the GRS 80 ellipsoid
class GRS80 < Ellipsoid
  # Default initializer, sets parameters of the ellipsoid
  def initialize
    @a = 6378137.0
    @b = 6356752.314140
    @f = 1/298.257222101
  end
end

# This class represents the INTERNATIONAL 1924 ellipsoid
# Associated with the ED 1950 datum
class GRS80 < Ellipsoid
  # Default initializer, sets parameters of the ellipsoid
  def initialize
    @a = 6378388.0
    @b = 6356911.946
    @f = 1/296.9999982305938
  end
end