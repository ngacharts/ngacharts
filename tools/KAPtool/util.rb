# The helper classes
#
# Author::    Pavel Kalian  (mailto:pavel@kalian.cz)
# Copyright:: Copyright (c) 2011 Pavel Kalian
# License::   Distributes under the terms of GPLv2 or later

# Utility functions class
# This class contains constants and methods used for the computations
class Util
  # PI
  #PI = 3.1415926535897931160E0
  PI = Math::PI
  # Conversion from degree to radian
  DEGREE = PI / 180.0
  # Conversion from radian to degree
  RADIAN = 180.0 / PI
  # Nautical mile in meters
  NAUTICAL_MILE = 1852
  
  # Distance in meters
  def Util.distance_meters(lat_a, long_a, lat_b, long_b)
    return Util.distance(lat_a, long_a, lat_b, long_b) * RADIAN * 60 * Util::NAUTICAL_MILE 
  end
  
  # Great Circle Distance
  # arguments in radians
  # taken from gc.rb
  def Util.distance(lat_a,long_a,lat_b,long_b)
    distance = Math.acos( Math.cos(lat_a) * Math.cos(lat_b) * Math.cos(diff_long(long_a,long_b)) + Math.sin(lat_a) * Math.sin(lat_b))
    return distance 
  end
  
  private
  # long diff
  # taken from gc.rb
  def Util.diff_long(longS, longD)
    longS = longS.to_f 
    longD = longD.to_f 
    
    if (longS.abs + longD.abs) <= PI
      diff = longD - longS
      
    elsif (longS.abs + longD.abs) > PI
      if longS > 0 && longD < 0  # heading E
        diff = 2.0 * PI + (longD - longS)
      elsif longS < 0 && longD > 0  # heading W
        diff = (longD - longS) - 2.0 * PI
      elsif (longS > 0 && longD > 0 )||( longS < 0 && longD < 0)
         diff = longD - longS
      end
    end
    return diff
  end

  # Prints the human readable format of latitude
  def Util.print_lat(degrees)
    d = degrees.abs.floor
    m = (degrees.abs - d) * 60
    h = 'N'
    if (degrees < 0.0) then h = 'S' end
    puts sprintf("%i d %.3f m %s", d, m, h)
  end
  
  # Prints the human readable format of longitude
  def Util.print_lon(degrees)
    d = degrees.abs.floor
    m = (degrees.abs - d) * 60
    h = 'E'
    if (degrees < 0.0) then h = 'W' end
    puts sprintf("%i d %.3f m %s", d, m, h)
  end
end
