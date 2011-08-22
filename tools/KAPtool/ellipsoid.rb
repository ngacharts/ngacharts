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
  
  # Calculates geodetic distance between two points specified by latitude/longitude using Vincenty inverse formula for ellipsoids<br/>
  # Based on original JavaScript implementation (c) Chris Veness 2002-2010 - http://www.movable-type.co.uk/scripts/latlong-vincenty.html 
  def vicenty_distance(lat1, lon1, lat2, lon2)
    l = (lon2-lon1) * Util::DEGREE
    u1 = Math.atan((1 - f) * Math.tan(lat1 * Util::DEGREE))
    u2 = Math.atan((1 - f) * Math.tan(lat2 * Util::DEGREE));
    sinU1 = Math.sin(u1)
    cosU1 = Math.cos(u1)
    sinU2 = Math.sin(u2)
    cosU2 = Math.cos(u2)
  
    lambda = l
    lambdaP = 100
    iterLimit = 100
    while ((lambda - lambdaP).abs > 1e-12 && --iterLimit > 0) do
      sinLambda = Math.sin(lambda)
      cosLambda = Math.cos(lambda)
      sinSigma = Math.sqrt((cosU2 * sinLambda) * (cosU2 * sinLambda) + (cosU1 * sinU2 - sinU1 * cosU2 * cosLambda) * (cosU1 * sinU2 - sinU1 * cosU2 * cosLambda))
      if (sinSigma==0) then return 0 end # coincident points
      cosSigma = sinU1 * sinU2 + cosU1 * cosU2 * cosLambda
      sigma = Math.atan2(sinSigma, cosSigma)
      sinAlpha = cosU1 * cosU2 * sinLambda / sinSigma
      cosSqAlpha = 1 - sinAlpha * sinAlpha
      cos2SigmaM = cosSigma - 2 * sinU1 * sinU2 / cosSqAlpha
      if (cos2SigmaM) then cos2SigmaM = 0 end  # equatorial line: cosSqAlpha=0 (§6)
      c = f / 16 * cosSqAlpha * (4 + f * (4 - 3 * cosSqAlpha))
      lambdaP = lambda
      lambda = l + (1 - c) * f * sinAlpha * (sigma + c * sinSigma * (cos2SigmaM + c * cosSigma * (-1 + 2 * cos2SigmaM * cos2SigmaM)))
    end
  
    if (iterLimit == 0) then return nil end  # formula failed to converge
  
    uSq = cosSqAlpha * (a**2 - b**2) / b**2;
    vA = 1 + uSq / 16384 * (4096 + uSq * (-768 + uSq * (320 - 175 * uSq)))
    vB = uSq / 1024 * (256 + uSq * (-128 + uSq * (74 - 47 * uSq)))
    deltaSigma = vB * sinSigma * (cos2SigmaM + vB / 4 * (cosSigma * (-1 + 2 * cos2SigmaM * cos2SigmaM) - vB / 6 * cos2SigmaM * (-3 + 4 * sinSigma * sinSigma) * (-3 + 4 * cos2SigmaM * cos2SigmaM)))
    s = b * vA * (sigma - deltaSigma)
    
    return s
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