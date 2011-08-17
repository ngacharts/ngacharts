# The program handles the KAP chart files
#
# Author::    Pavel Kalian  (mailto:pavel@kalian.cz)
# Copyright:: Copyright (c) 2011 Pavel Kalian
# Portions from gc.rb script Copyright (C) 2009 by Thomas Hockne
# License::   Distributes under the terms of GPLv2 or later

if (RUBY_VERSION.start_with?("1.9"))
  require "Mysql"
else
  require "mysql"
end
require "./bsb.rb"
require "./kap.rb"

require "./config.rb"


# This class represents a single paper chart
class Chart
  # Chart number
  attr_accessor :number
  # BSB file representing the chart
  attr_accessor :bsb
  # array of KAPs representing the chart
  attr_accessor :kaps
  
  # Default constructor
  def initialize
    @kaps = Array.new
  end
  
  # Loads the chart from the database
  # TODO: Now it simplifies everything for testing and has to be rewritten for real world use
  def load_from_db #TODO - now we load it simply for phase 1 - from the view, has to be redone to actually work well
    res = $dbh.query("SELECT * FROM ocpn_nga_charts_with_params WHERE number=#{@number}")

    while row = res.fetch_hash do
      #puts row.inspect
      @bsb = BSB.new
      @bsb.comment = "!This chart originates from
!http://www.nauticalcharts.noaa.gov/mcd/OnLineViewer.html
!DO NOT USE FOR NAVIGATION
!Use official, full scale nautical charts for real-world navigation.
!These are available from authorized nautical chart sales agents.
!Screen captures of the charts available here do NOT fulfill chart
!carriage requirements for regulated commercial vessels under
!Titles 33 and 46 of the Code of Federal Regulations."
      @bsb.ver = "2.0"
      @bsb.crr = "This chart is released by the OpenCPN.info - NGA chart project."
      @bsb.cht_na = row["title"]
      @bsb.cht_nu = row["number"]
      @bsb.chf = row["bsb_chf"]
      @bsb.org = "NGA"
      @bsb.mfr = "NGA chart project"
      @bsb.cgd = 0
      @bsb.ced_se = row["date"] #row["edition"]
      @bsb.ced_re = 1 #TODO - parameter of our process
      @bsb.ced_ed = 1 #TODO - parameter of our process
      @bsb.ntm_ne = row["edition"]
      @bsb.ntm_nd = row["correction"]
      @bsb.ntm_bf = "UNKNOWN"
      @bsb.ntm_bd = "UNKNOWN"
      
      ki = KAPinfo.new
      ki.idx = @bsb.kap.length + 1
      ki.na = row["title"]
      ki.nu = row["number"]
      ki.ty = row["bsb_type"]
      ki.fn = row["number"] + ".kap"
      @bsb.kap << ki
      @bsb.chk = @bsb.kap.length
      
      kap = KAPHeader.new
      kap.comment = "!This chart originates from
!http://www.nauticalcharts.noaa.gov/mcd/OnLineViewer.html
!DO NOT USE FOR NAVIGATION
!Use official, full scale nautical charts for real-world navigation.
!These are available from authorized nautical chart sales agents.
!Screen captures of the charts available here do NOT fulfill chart
!carriage requirements for regulated commercial vessels under
!Titles 33 and 46 of the Code of Federal Regulations."
      kap.ver = "2.0"
      kap.crr = "This chart is released by the OpenCPN.info - NGA chart project."
      kap.bsb_na = row["title"]
      kap.bsb_nu = row["number"]
      kap.bsb_ra = [row["width"].to_i, row["height"].to_i]
      kap.bsb_du = 72 # TODO - Will we bother with the DPI claculation?
      
      kap.ced_se = row["date"] #row["edition"]
      kap.ced_re = 1 #TODO - parameter of our process
      kap.ced_ed = 1 #TODO - parameter of our process
      
      kap.knp_sc = row["scale"]
      kap.knp_gd = row["GD"] # should be used in case we don't have a datum for plotting available - it's handled by compute_gd later
      kap.knp_pr = row["PR"]
      kap.knp_pp = row["PP"]
      kap.knp_pi = "UNKNOWN"
      kap.knp_sk = 0.0 #TODO - generally we do not want the skewed charts, but...
      kap.knp_ta = 90.0 # probably true for all the charts 
      kap.knp_un = row["UN"]
      kap.knp_sd = row["SD"]
      kap.knp_sp = "UNKNOWN"

      kap.dtm = [-1 * row["DTMy"].to_f * 60, -1 * row["DTMx"].to_f * 60] #convert to seconds and reverse the sign
      if (kap.dtm[0] == -0.0) then kap.dtm[0] = 0.0 end
      if (kap.dtm[1] == -0.0) then kap.dtm[1] = 0.0 end
      kap.dtm_dat = row["DTMdat"]
      kap.ifm = 5 #TODO - parameter of our process
      kap.ost = 1
      
      sw = REF.new
      sw.idx = 1
      sw.x = row["Xsw"].to_i
      sw.y = row["Ysw"].to_i
      sw.latitude = row["South"].to_f
      sw.longitude = row["West"].to_f
      kap.ref << sw
      kap.ply << sw.to_PLY
      
      nw = REF.new
      nw.idx = 2
      nw.x = row["Xnw"].to_i
      nw.y = row["Ynw"].to_i
      nw.latitude = row["North"].to_f
      nw.longitude = row["West"].to_f
      kap.ref << nw
      kap.ply << nw.to_PLY
      
      ne = REF.new
      ne.idx = 3
      ne.x = row["Xne"].to_i
      ne.y = row["Yne"].to_i
      ne.latitude = row["North"].to_f
      ne.longitude = row["East"].to_f
      kap.ref << ne
      kap.ply << ne.to_PLY
      
      se = REF.new
      se.idx = 4
      se.x = row["Xse"].to_i
      se.y = row["Yse"].to_i
      se.latitude = row["South"].to_f
      se.longitude = row["East"].to_f
      kap.ref << se
      kap.ply << se.to_PLY
      
      if (kap.knp_pp == nil) then kap.compute_pp end
      kap.compute_cph
      kap.compute_gd
      kap.compute_dxdy
      
      @kaps << kap
    end

    res.free
  end
  
  # Produces the chart
  def produce(number, percent, autorotate = false)
    output_dir = $output_dir.gsub("{CHART_NUMBER}", number.to_s)
    jpg_path = $jpg_path.gsub("{CHART_NUMBER}", number.to_s)
    
    # load from db
    @number =  number
    load_from_db
    
    # resize header
    @kaps[0].resize_to_percent(percent)
    
    # create resized image 
    if (autorotate && @kaps[0].suggest_rotation.abs > $skew_angle) #if the skew is smaller than $skew_angle, we rotate the chart
      `#{$convert_command} #{jpg_path} -level 5% -resize #{percent}% -rotate #{@kaps[0].suggest_rotation} -depth 8 -colors 32 -type Palette png8:#{output_dir}/#{number}.png`
      @kaps[0].rotate(@kaps[0].suggest_rotation)
    else
      `#{$convert_command} #{jpg_path} -level 5% -resize #{percent}% -depth 8 -colors 32 -type Palette png8:#{output_dir}/#{number}.png`
    end
    
    # create BSB
    File.open("#{output_dir}/#{number}.bsb", "w") {|file|
      file << @bsb
      file.close
      }
    # produce the KAP
    File.open("#{output_dir}/#{number}.txt", "w") {|file|
      file << @kaps[0]
      file.close
      }
    `#{$imgkap_command} -p NONE -n #{output_dir}/#{number}.png #{output_dir}/#{number}.txt #{output_dir}/#{number}.kap`
  end
end

# Utility functions class
# This class contains constants and methods used for the computations
class Util
  # PI
  PI = 3.1415926535897931160E0
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
end

# test for the routines getting latitude and longitude corresponding with a given pixel in the image
def test_getlatlon
  k = KAPHeader.new
  k.bsb_ra = [40, 40]
  r = REF.new
  r.x = 10
  r.y = 30
  r.latitude = -10
  r.longitude = 170
  k.ref << r
  r = REF.new
  r.x = 10
  r.y = 10
  r.latitude = 10
  r.longitude = 170
  k.ref << r
  r = REF.new
  r.x = 30
  r.y = 10
  r.latitude = 10
  r.longitude = -170
  k.ref << r
  r = REF.new
  r.x = 30
  r.y = 30
  r.latitude = -10
  r.longitude = -170
  k.ref << r
  puts k.inspect
  puts k.lat_at_y (11)
  puts k.lon_at_x (11)
  puts k.lat_at_y (21)
  puts k.lon_at_x (21)
  
  k = KAPHeader.new
  k.bsb_ra = [40, 40]
  r = REF.new
  r.x = 10
  r.y = 30
  r.latitude = -10
  r.longitude = -10
  k.ref << r
  r = REF.new
  r.x = 10
  r.y = 10
  r.latitude = 10
  r.longitude = -10
  k.ref << r
  r = REF.new
  r.x = 30
  r.y = 10
  r.latitude = 10
  r.longitude = 10
  k.ref << r
  r = REF.new
  r.x = 30
  r.y = 30
  r.latitude = -10
  r.longitude = 10
  k.ref << r
  puts k.inspect
  puts k.lat_at_y (11)
  puts k.lon_at_x (11)
  puts k.lat_at_y (21)
  puts k.lon_at_x (21)
end

begin
  test_getlatlon
  # connect to the MySQL server
  $dbh = Mysql.connect($db_host, $db_username, $db_password, $db_database)
  # get server version string and display it
  #puts "Server version: " + $dbh.get_server_info
  
  chart = Chart.new
  chart.produce(37112, 100, true)
  chart.kaps[0].check
  puts chart.kaps[0].lat_at_y(chart.kaps[0].ref[0].y)
  puts chart.kaps[0].lon_at_x(chart.kaps[0].ref[0].x)
  puts chart.kaps[0].ref[0].inspect
  
rescue Mysql::Error => e
  puts "Error code: #{e.errno}"
  puts "Error message: #{e.error}"
  puts "Error SQLSTATE: #{e.sqlstate}" if e.respond_to?("sqlstate")
  
ensure
  # disconnect from server
  $dbh.close if $dbh
end