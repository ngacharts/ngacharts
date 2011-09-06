# The program handles the KAP chart files and BSB files
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
require "./util.rb"
require "./bsb.rb"
require "./kap.rb"
require "./ellipsoid.rb"
require "./projection.rb"

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

  # Generates the 'BASE' KAPs for all the newly calibrated charts
  def Chart.process_new_base_calibrations
    res = $dbh.query("SELECT number FROM ocpn_nga_charts_with_params WHERE status_id IN (1, 2, 3, 14) AND kap_generated IS NULL AND North IS NOT NULL AND South IS NOT NULL AND East IS NOT NULL AND West IS NOT NULL AND Xsw IS NOT NULL AND Ysw IS NOT NULL AND Xnw IS NOT NULL AND Ynw IS NOT NULL AND Xne IS NOT NULL AND Yne AND Xse IS NOT NULL AND Yse IS NOT NULL")

    while row = res.fetch_hash do
      puts "Processing chart #{row["number"]}"
      chart = Chart.new
      chart.produce(row["number"], $kap_size_percent, $kap_autorotate)
    end
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
#    $dbh.query("UPDATE ocpn_nga_kap SET kap_generated = CURRENT_TIMESTAMP() WHERE bsb_type = 'BASE' AND number=#{@number}")
  end
  
  # Produces the chart
  def produce(number, percent, autorotate = false)
    output_dir = $output_dir.gsub("{CHART_NUMBER}", number.to_s)
    jpg_path = $jpg_path.gsub("{CHART_NUMBER}", number.to_s)
    
    # load from db
    @number =  number
    load_from_db

    rotation = @kaps[0].suggest_rotation
    puts "Suggested rotation: #{rotation}";
    puts "Original calibration:"
    puts @kaps[0].inspect
        
    # resize header
    #@kaps[0].resize_to_percent(percent)
    
    # create resized image 
    if (autorotate && rotation.abs > $skew_angle) #if the skew is smaller than $skew_angle, we rotate the chart
      @kaps[0].rotate(rotation)
      puts "Rotated kap:"
      puts @kaps[0].inspect
      @kaps[0].resize_to_percent(percent)
      puts "Resized kap:"
      puts @kaps[0].inspect
      `#{$convert_command} #{jpg_path} -limit memory 2048MB -level 5% -resize #{percent}% -rotate #{rotation} -despeckle -crop #{@kaps[0].bsb_ra[0]}x#{@kaps[0].bsb_ra[1]}+0+0 -depth 8 -colors 32 -type Palette png8:#{output_dir}/#{number}.png`
    else
      @kaps[0].resize_to_percent(percent)
      `#{$convert_command} #{jpg_path} -limit memory 2048MB -level 5% -resize #{percent}% -despeckle -crop #{@kaps[0].bsb_ra[0]}x#{@kaps[0].bsb_ra[1]}+0+0 -depth 8 -colors 32 -type Palette png8:#{output_dir}/#{number}.png`
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
    $dbh.query("UPDATE ocpn_nga_kap SET kap_generated = CURRENT_TIMESTAMP() WHERE bsb_type = 'BASE' AND number=#{@number}")
  end
end

begin
  # connect to the MySQL server
  $dbh = Mysql.connect($db_host, $db_username, $db_password, $db_database)
  # get server version string and display it
  #puts "Server version: " + $dbh.get_server_info
  # check the lock nd exit if it exists
  if (File.exists?($lock_path))
    puts "KAPTool already running, exiting."
    Process.exit
  end
  f = File.new($lock_path,"w")
  begin
    f.puts "Locked at #{Time.now.asctime}"
  ensure
    f.close
  end

  Chart.process_new_base_calibrations

  #puts chart.kaps[0].lat_at_y(chart.kaps[0].ref[0].y)
  #puts chart.kaps[0].lon_at_x(chart.kaps[0].ref[0].x)
  #puts chart.kaps[0].x_at(chart.kaps[0].ref[3].longitude)
  #puts chart.kaps[0].y_at(chart.kaps[0].ref[3].latitude)
  #puts chart.kaps[0].x_at(1.25)
  #puts chart.kaps[0].y_at(50.0)
  #puts chart.kaps[0].lon_at(3386)
  #puts chart.kaps[0].lat_at(2585)
  #puts chart.kaps[0].inspect
  # delete lock
  File.unlink($lock_path)
rescue Mysql::Error => e
  puts "Error code: #{e.errno}"
  puts "Error message: #{e.error}"
  puts "Error SQLSTATE: #{e.sqlstate}" if e.respond_to?("sqlstate")
  
ensure
  # disconnect from server
  $dbh.close if $dbh
end
