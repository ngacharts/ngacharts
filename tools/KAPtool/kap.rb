# The classes for handling the KAP chart files
#
# Author::    Pavel Kalian  (mailto:pavel@kalian.cz)
# Copyright:: Copyright (c) 2011 Pavel Kalian
# Portions from gc.rb script Copyright (C) 2009 by Thomas Hockne
# License::   Distributes under the terms of GPLv2 or later

# This class represents the KAP chart header<br/>
# The chapter numbers refer to IHO standard document S-61: http://88.208.211.37/iho_pubs/standard/S61E.pdf<br/>
# The state copies the information for BSB Version 3.0, as described documents available from http://88.208.211.37/iho_pubs/standard/S-64_Edition_1-1/RNC_Test_Data_Sets/BSB_TDS/BSB_TDS.htm<br/>
class KAPHeader
  # File comment, lines starting with ! 
  attr_accessor :comment
  # Format version
  attr_accessor :ver
  # Copyright Record
  attr_accessor :crr
  
  # BSB   General Parameters
      
  # NA - Chart Name  (3.4.2.2 RNC Name)
  attr_accessor :bsb_na
  # NU - Chart Number  (3.4.2.2 RNC number)
  attr_accessor :bsb_nu
  # RA - Image Width Height - two comma separated numbers representing the pixel dimensions
  attr_accessor :bsb_ra
  # DU - Drawing Units (3.4.2.15  Pixel resolution of the image file)
  attr_accessor :bsb_du

  # KNP   Detailed Parameters   
  
  # SC- Scale (3.4.2.8 Chart scale)
  attr_accessor :knp_sc
  # GD - Geodetic Datum Name (3.4.2.11  Horizontal datum)
  attr_accessor :knp_gd
  # PR - Projection Name (3.4.2.10 Projection and associated projection parameters)
  attr_accessor :knp_pr
  # PP - Projection Parameter  (3.4.2.10 Projection and associated projection parameters)
  attr_accessor :knp_pp
  # PI - Projection Interval (3.4.2.10 Projection and associated projection parameters)
  attr_accessor :knp_pi
  # SK - Skew Angel  (3.4.2.9 Orientation of north)
  attr_accessor :knp_sk
  # TA - Text Angle
  attr_accessor :knp_ta
  # UN - Depth Units (3.4.2.14 Depth and height units)
  attr_accessor :knp_un
  # SD - Sounding Datum (3.4.2.13 Vertical datums)
  attr_accessor :knp_sd
  # DX - X Resolution - meters per pixel, one decimal place
  attr_accessor :knp_dx
  # DY - Y Resolution - meters per pixel, one decimal place
  attr_accessor :knp_dy
  # SP - ??? - Not documented, but exists in the collected KAPs
  attr_accessor :knp_sp
  
  # CED   Edition Parameters
  
  # SE - Source Edition (3.4.2.5 Chart edition date and/or chart edition number)
  attr_accessor :ced_se
  # RE - Raster Edition
  attr_accessor :ced_re
  # ED - Edition Date (3.4.2.5 Chart edition date and/or chart edition number)
  attr_accessor :ced_ed
  
  # NTM   NTM Record    
  
  # NE - NTM Edition Number
  attr_accessor :ntm_ne
  # ND - NTM Date (3.4.2.6 Last update or NTM applied)
  attr_accessor :ntm_nd
  # BF - Base Flag
  attr_accessor :ntm_bf
  # BD - Base Date
  attr_accessor :ntm_bd
  
  # OST - Offset Values Section
  attr_accessor :ost
  # IFM - Compression Type
  attr_accessor :ifm
  # RGB - Default Color Palette (3.4.2.17.1  Colors used for daytime viewing)
  attr_accessor :rgb
  # DAY - Day Color Palette (3.4.2.17.1  Colors used for daytime viewing)
  attr_accessor :day
  # DSK - Dusk Color Palette (3.4.2.17.2  Colors used for dusk and nighttime)
  attr_accessor :dsk
  # NGT - Night Color Palette (3.4.2.17.2  Colors used for dusk and nighttime)
  attr_accessor :ngt
  # NGR - Night Red Palette
  attr_accessor :ngr
  # GRY - ??? - undocumented palette
  attr_accessor :gry
  # PRC - ??? - undocumented palette
  attr_accessor :prc
  # PRG - ??? - undocumented palette
  attr_accessor :prg

  # REF - Reference Point Record (3.4.2.16  Mechanism to allow geographical positions to be converted to RNC (pixel) coordinates)
  # multiple records
  attr_accessor :ref
  # CPH - Phase Shift Value
  attr_accessor :cph
  # TODO: WPX - Polynomial L to X
  # Format:<br/>
  ## WPX/2,863264.4957,11420.23114,-85.46756208,1.913941167,-0.4081181078
  ##     0.7362163163
  attr_accessor :wpx # TODO
  # TODO: PWX - Polynomial X to L
  # Format:
  ## PWX/2,-76.48368342,8.999135076e-005,5.758392982e-009,-1.392859319e-012
  ##     -2.377189159e-013,-3.432372134e-013
  attr_accessor :pwx # TODO
  # TODO: WPY - Polynomial L to Y
  # Format:
  ## WPY/2,390032.0953,69.56409751,-6745.589267,0.4669253601,0.0367153316
  ##     -96.0547565
  attr_accessor :wpy # TODO
  # TODO: PWY - Polynomial Y to L
  # Format:
  ## PWY/2,37.44988807,-3.111799225e-009,-7.171936009e-005,2.694372983e-013
  ##     -1.725045227e-014,-3.594145418e-011
  attr_accessor :pwy # TODO
  # TODO: ERR - Error Record
  # Format: multiple records
  ## ERR/1,0.0395099814,0.1453734568,0.0000106128,0.0000035393
  attr_accessor :err # TODO
  # PLY - Border Polygon Record
  # multiple records
  attr_accessor :ply
  # DTM - Datum Shift Record (3.4.2.12  Horizontal datum shift to WGS84)
  # Format: Two comma separated numbers
  attr_accessor :dtm
  # DTM datum - the datum to which the shift is related (normally WGS84, sometimes WGS72 etc.)
  attr_accessor :dtm_dat
  
  # KNQ - Observed, but not documented anywhere
  # Seems mandatory in version 3.0 - Caris Easy View refuses to load charts stating being version 3.0 and not containing this section
  # Format:
  ## KNQ/EC=RF,GD=NARC,VC=UNKNOWN,SC=MLLW,PC=MC,P1=UNKNOWN,P2=37.083
  ##     P3=NOT_APPLICABLE,P4=NOT_APPLICABLE,GC=NOT_APPLICABLE,RM=POLYNOMIAL
  
  #EC - ???
  attr_accessor :knq_ec
  #GD - ???
  attr_accessor :knq_gd
  #VC - ???
  attr_accessor :knq_vc
  #SC - ???
  attr_accessor :knq_sc
  #PC - ???
  attr_accessor :knq_pc
  #P1 - ???
  attr_accessor :knq_p1
  #P2 - ???
  attr_accessor :knq_p2
  #P3 - ???
  attr_accessor :knq_p3
  #P4 - ???
  attr_accessor :knq_p4
  #GC - ???
  attr_accessor :knq_gc
  #RM - ???
  attr_accessor :knq_rm
  
  # Default initializer
  def initialize
    @comment = String.new
    @crr = String.new
    @ref = Array.new
    @ply = Array.new
    @rgb = Array.new
    @day = Array.new
    @dsk = Array.new
    @ngt = Array.new
    @ngr = Array.new
    @gry = Array.new
    @prc = Array.new
    @prg = Array.new
  end

  # Parses the string and finds the value for the key
  def parse_key_value(header, key, from, to)
    hdr = header[from..to]
    if(hdr.include?(key))
      begidx = hdr.index(key) + key.length
      endidx = hdr.index(/[,\n\r]/, begidx)
      return hdr[begidx..(endidx - 1)]
    else
      return nil
    end
  end
  
  # Recalculates positions of all the ref points for the chart rotated around it's center by supplied amount of degrees
  def rotate(deg)
    angle = Util::DEGREE * deg
    width = @bsb_ra[0].to_i
    height = @bsb_ra[1].to_i
    center_x = width.to_f  / 2
    center_y = height.to_f / 2
    new_width = (2 * Math.sqrt(center_x**2 + center_y**2) * Math.cos(Math.atan(center_y / center_x) + deg * Util::DEGREE)).round
    new_height = (2 * Math.sqrt(center_x**2 + center_y**2) * Math.sin(Math.atan(center_y / center_x) - deg * Util::DEGREE)).round
    xadd = ((new_width - width) / 2).round
    yadd = ((new_height - height) / 2).round
    @ref.each {|ref|
      xxc = ref.x - center_x
      yyc = ref.y - center_y
      x1xc = Math.cos(angle) * xxc - Math.sin(angle) * yyc
      y1yc = Math.sin(angle) * xxc + Math.cos(angle) * yyc
      ref.x = (x1xc + center_x + xadd).round
      ref.y = (y1yc + center_y + yadd).round
      }
      
      @bsb_ra = [new_width, new_height]
  end
  
  # Computes suggested rotation from the ref points
  # TODO: It works correctly just for the charts with exactly 4 REF points defining the chart rectangle
  def suggest_rotation
    sw_x = sw_y = nw_x = nw_y = ne_x = ne_y = se_x = se_y = nil
    @ref.each {|ref|
      if (ref.idx == 1)
        sw_x = ref.x
        sw_y = ref.y
      end
      if (ref.idx == 2)
        nw_x = ref.x
        nw_y = ref.y
      end
      if (ref.idx == 3)
        ne_x = ref.x
        ne_y = ref.y
      end
      if (ref.idx == 4)
        se_x = ref.x
        se_y = ref.y
      end
      }
    sk_rec = 0
    sk_nr = 0
    if (!sw_x.nil? && !nw_x.nil?)
      sk_left = Util::RADIAN * Math.atan((sw_x-nw_x).to_f  / (sw_y-nw_y).to_f )
      sk_nr += 1
      sk_rec += sk_left 
    end
    if (!se_x.nil? && !nw_x.nil?) 
      sk_right = Util::RADIAN * Math.atan((se_x-ne_x).to_f / (se_y-ne_y))
      sk_nr += 1
      sk_rec += sk_right
    end
    if (!ne_x.nil? && !nw_x.nil?)
      sk_top = Util::RADIAN * Math.atan((nw_y-ne_y).to_f / (ne_x-nw_x))
      sk_nr += 1
      sk_rec += sk_top
    end
    if (!sw_x.nil? && !se_x.nil?)
      sk_bottom = Util::RADIAN * Math.atan((sw_y-se_y).to_f / (se_x-sw_x))
      sk_nr += 1
      sk_rec += sk_bottom
    end
    sk_rec = sk_rec / sk_nr
    return sprintf("%.2f", sk_rec).to_f
  end
  
  # Checks the data for correctness
  # Calculates angles of the chart edges to estimate the skew
  # TODO: It works correctly just for the charts with exactly 4 REF points defining the chart rectangle
  def check
    if (@ref.count < 4)
      puts "Not enough REF points"
    end
    if (@ply.length != 0 && @ply.length < 4)
      puts "Not enough PLY points"
    end
    if (@rgb.length != 0 && rgb.length > 2**@ifm)
      puts "The RGB color table looks corrupted or IFM set wrong, should have maximum #{2**@ifm} colors, but has #{@rgb.length}"
    end
    # 
    sw_x = sw_y = nw_x = nw_y = ne_x = ne_y = se_x = se_y = nil
    @ref.each {|ref|
      if (ref.idx == 1)
        sw_x = ref.x
        sw_y = ref.y
      end
      if (ref.idx == 2)
        nw_x = ref.x
        nw_y = ref.y
      end
      if (ref.idx == 3)
        ne_x = ref.x
        ne_y = ref.y
      end
      if (ref.idx == 4)
        se_x = ref.x
        se_y = ref.y
      end
      }
    sk_rec = 0
    sk_nr = 0
    if (!sw_x.nil? && !nw_x.nil?)
      sk_left = Util::RADIAN * Math.atan((sw_x-nw_x).to_f  / (sw_y-nw_y).to_f )
      sk_nr += 1
      sk_rec += sk_left 
    end
    if (!se_x.nil? && !nw_x.nil?) 
      sk_right = Util::RADIAN * Math.atan((se_x-ne_x).to_f / (se_y-ne_y))
      sk_nr += 1
      sk_rec += sk_right
    end
    if (!ne_x.nil? && !nw_x.nil?)
      sk_top = Util::RADIAN * Math.atan((nw_y-ne_y).to_f / (ne_x-nw_x))
      sk_nr += 1
      sk_rec += sk_top
    end
    if (!sw_x.nil? && !se_x.nil?)
      sk_bottom = Util::RADIAN * Math.atan((sw_y-se_y).to_f / (se_x-sw_x))
      sk_nr += 1
      sk_rec += sk_bottom
    end
    sk_rec = sk_rec / sk_nr
    puts sprintf("Skew: left: %.3f, right %.3f, top: %.3f, bottom: %.3f degrees", sk_left, sk_right, sk_top, sk_bottom)
    puts sprintf("Recommended image rotation: %.3f degrees", sk_rec)
  end

  # Parses the chart header text
  def readheader(header_text)
    previous_was_crr = false
    header_text.each_line { |line|
      if (line.strip[0] == '!')
      @comment << line
      end
      if (line.index("CRR/") != nil || (previous_was_crr && line.start_with?("    ")))
        @crr << line
        previous_was_crr = true
      else
        previous_was_crr = false
      end
      if (line.index("REF") != nil)
        @ref << REF.new(line)
      end
      if (line.index("PLY") != nil)
        @ply << PLY.new(line)
      end
      if (line.index("RGB/") != nil)
        @rgb << Color.new(line)
      end
      if (line.index("DAY/") != nil)
        @day << Color.new(line)
      end
      if (line.index("DSK/") != nil)
        @dsk << Color.new(line)
      end
      if (line.index("NGT/") != nil)
        @ngt << Color.new(line)
      end
      if (line.index("NGR/") != nil)
        @ngr << Color.new(line)
      end
      if (line.index("GRY/") != nil)
        @gry << Color.new(line)
      end
      if (line.index("PRC/") != nil)
        @prc << Color.new(line)
      end
      if (line.index("PRG/") != nil)
        @prg << Color.new(line)
      end
    }

    bsb_start = header_text.index("BSB/")
    if (bsb_start != nil)
      bsb_end = header_text.index(/[A-Z]{3}\//, bsb_start + 4)
      if (bsb_end == nil)
        bsb_end = header_text.length
      end
      @bsb_na = parse_key_value(header_text, "NA=", bsb_start, bsb_end)
      @bsb_nu = parse_key_value(header_text, "NU=", bsb_start, bsb_end)
      begidx = header_text.index("RA=", bsb_start) + "RA=".length
      endidx = header_text.index(",", begidx)
      endidx = header_text.index(",", endidx + 1)
      @bsb_ra = header_text[begidx, endidx-begidx].split(',')
      @bsb_du = parse_key_value(header_text, "DU=", bsb_start, bsb_end)
    end
    
    knp_start = header_text.index("KNP/")
    if (knp_start != nil)
      knp_end = header_text.index(/[A-Z]{3}\//, knp_start + 4)
      if (knp_end == nil)
        knp_end = header_text.length
      end
      @knp_sc = parse_key_value(header_text, "SC=", knp_start, knp_end)
      @knp_gd = parse_key_value(header_text, "GD=", knp_start, knp_end)
      @knp_pr = parse_key_value(header_text, "PR=", knp_start, knp_end)
      @knp_pp = parse_key_value(header_text, "PP=", knp_start, knp_end)
      @knp_pi = parse_key_value(header_text, "PI=", knp_start, knp_end)
  
      #Hard to say if it has 1 or 2 components... we don't even know what it is...
      begidx = header_text.index("SP=", knp_start) + "SP=".length
      endidx = header_text.index(",", begidx)
      endidx = header_text.index(",", endidx + 1)
      if (endidx < header_text.index("=", begidx))
        @knp_sp = header_text[begidx, endidx-begidx].split(',')
      else
        @knp_sp = Array.new
        @knp_sp[0] = parse_key_value(header_text, "SP=", knp_start, knp_end)
      end
  
      @knp_ta = parse_key_value(header_text, "TA=", knp_start, knp_end)
      @knp_sk = parse_key_value(header_text, "SK=", knp_start, knp_end)
      @knp_un = parse_key_value(header_text, "UN=", knp_start, knp_end)
      @knp_sd = parse_key_value(header_text, "SD=", knp_start, knp_end)
      @knp_dx = parse_key_value(header_text, "DX=", knp_start, knp_end)
      @knp_dy = parse_key_value(header_text, "DY=", knp_start, knp_end)
    end
    
    knq_start = header_text.index("KNQ/")
    if (knq_start != nil)
      knq_end = header_text.index(/[A-Z]{3}\//, knq_start + 4)
      if (knq_end == nil)
        knq_end = header_text.length
      end
      @knq_ec = parse_key_value(header_text, "EC=", knq_start, knq_end)
      @knq_gd = parse_key_value(header_text, "GD=", knq_start, knq_end)
      @knq_vc = parse_key_value(header_text, "VC=", knq_start, knq_end)
      @knq_sc = parse_key_value(header_text, "SC=", knq_start, knq_end)
      @knq_pc = parse_key_value(header_text, "PC=", knq_start, knq_end)
      @knq_p1 = parse_key_value(header_text, "P1=", knq_start, knq_end)
      @knq_p2 = parse_key_value(header_text, "P2=", knq_start, knq_end)
      @knq_p3 = parse_key_value(header_text, "P3=", knq_start, knq_end)
      @knq_p4 = parse_key_value(header_text, "P4=", knq_start, knq_end)
      @knq_gc = parse_key_value(header_text, "GC=", knq_start, knq_end)
      @knq_rm = parse_key_value(header_text, "RM=", knq_start, knq_end)
    end
    
    ced_start = header_text.index("CED/")
    if (ced_start != nil)
      ced_end = header_text.index(/[A-Z]{3}\//, ced_start + 4)
      if (ced_end == nil)
        ced_end = header_text.length
      end
      @ced_se = parse_key_value(header_text, "SE=", ced_start, ced_end)
      @ced_re = parse_key_value(header_text, "RE=", ced_start, ced_end)
      @ced_ed = parse_key_value(header_text, "ED=", ced_start, ced_end)
    end
    
    ntm_start = header_text.index("NTM/")
    if (ntm_start != nil)
      ntm_end = header_text.index(/[A-Z]{3}\//, ntm_start + 4)
      if (ntm_end == nil)
        ntm_end = header_text.length
      end
      @ntm_ne = parse_key_value(header_text, "NE=", ntm_start, ntm_end)
      @ntm_nd = parse_key_value(header_text, "ND=", ntm_start, ntm_end)
      @ntm_bf = parse_key_value(header_text, "BF=", ntm_start, ntm_end)
      @ntm_bd = parse_key_value(header_text, "BD=", ntm_start, ntm_end)
    end
    
    @ver = parse_key_value(header_text, "VER/", 0, header_text.length)
    @ost = parse_key_value(header_text, "OST/", 0, header_text.length)
    @ifm = parse_key_value(header_text, "IFM/", 0, header_text.length)
    @cph = parse_key_value(header_text, "CPH/", 0, header_text.length)

    if(header_text.include?("DTM/"))
      begidx = header_text.index("DTM/") + "DTM/".length
      endidx = header_text.index(",", begidx)
      endidx = header_text.index(/[,\n]/, endidx + 1)
      @dtm = header_text[begidx, endidx-begidx].split(',')
    end
  end
  
  # Set GD to the appropriate value
  # TODO: Is this correct
  def compute_gd
    if (@dtm_dat != nil && @dtm != nil)
      @knp_gd = @dtm_dat
    end
  end
  
  # Calculates the value for KNP/PP in case it was not given on the chart 
  # TODO: Are we going to handle it for more projections?
  def compute_pp
    if (@knp_pr == "MERCATOR")
      @knp_pp = (min_lat + max_lat) / 2
    end
    if (@knp_pr == "TRANSVERSE MERCATOR")
      @knp_pp = (min_lon + max_lon) / 2
    end
  end
  
  # returns true if the chart crosses the international dateline
  def crosses_dateline
    #search for the leftmost and rightmost ref and compare
    leftmost = @ref[0]
    rightmost = @ref[0]
    @ref.each{|ref|
      if ref.x > rightmost.x
        rightmost = ref
      end
      if ref.x < leftmost.x
        leftmost = ref
      end
      }
    if (leftmost.longitude > rightmost.longitude)
      return true
    else
      return false
    end
  end
  
  # Does the chart pass the date line? if so, CHP has to be 180.0, otherwise 0.0
  def compute_cph
    if (crosses_dateline)
      @cph = 180.0.to_s
    else
      @cph = 0.0.to_s
    end
  end
  
  # Gets the minimum latitude amongst all the REF points
  def min_lat
    min_lat = 90
    @ref.each {|point|
      if point.latitude.to_f < min_lat then min_lat = point.latitude.to_f end
      }
    return min_lat
  end
  
  # Gets the maximum latitude amongst all the REF points
  def max_lat
    max_lat = -90
    @ref.each {|point|
      if point.latitude.to_f > max_lat then max_lat = point.latitude.to_f end
      }
    return max_lat
  end
  
  # Gets the minimum longitude amongst all the REF points
  def min_lon
    min_lon = 180
    @ref.each {|point|
      if point.longitude.to_f < min_lon then min_lon = point.longitude.to_f end
      }
    return min_lon
  end
  
  # Gets the maximum longitude amongst all the REF points
  def max_lon
    max_lon = -180
    @ref.each {|point|
      if point.longitude.to_f > max_lon then max_lon = point.longitude.to_f end
      }
    return max_lon
  end
  
  # Gets the minimum x-coordinate amongst all the REF points
  def min_x
    min_x = @bsb_ra[0] 
    @ref.each {|point|
      if point.x < min_x then min_x = point.x end
      }
    return min_x
  end
  
  # Gets the maximum x-coordinate amongst all the REF points
  def max_x
    max_x = 0
    @ref.each {|point|
      if point.x > max_x then max_x = point.x end
      }
    return max_x
  end
  
  # Gets the minimum y-coordinate amongst all the REF points
  def min_y
    min_y = @bsb_ra[1]
    @ref.each {|point|
      if point.y < min_y then min_y = point.y end
      }
    return min_y
  end
  
  # Gets the maximum y-coordinate amongst all the REF points
  def max_y
    max_y = 0
    @ref.each {|point|
      if point.y > max_y then max_y = point.y end
      }
    return max_y
  end
  
  # Calculates meters per pixel value
  def compute_dxdy
    @knp_dx = Util.distance_meters(min_lat * Util::DEGREE, min_lon * Util::DEGREE, min_lat * Util::DEGREE, max_lon * Util::DEGREE) / (max_x - min_x)
    @knp_dy = Util.distance_meters(min_lat * Util::DEGREE, min_lon * Util::DEGREE, max_lat * Util::DEGREE, min_lon * Util::DEGREE) / (max_y - min_y) #TODO - Should this be computed at PP and in the middle of the other axis?
  end
  
  # Calculate latitude of a point at given y-axis coordinate
  # The algorithm hates any skew in the chart image and the accouracy deteriorates with the skew increasing.
  # If your chart is skewed or not mercator with those nice right angles between parallels and meridians, foorget about it.
  # The algorithm is simplified for our needs and uses the most extreme REF points in anticipation, that the chart is unskewed and rectangular, to achieve higher local precission, REF points as close as possible to the target coordinates should be used.
  def lat_at_y(y)
    yres = (max_lat - min_lat) / (max_y - min_y)
    return min_lat + yres * (max_y - y)
  end
  
  # Calculate longitude of a point at given x-axis coordinate
  # The algorithm hates any skew in the chart image and the accouracy deteriorates with the skew increasing.
  # If your chart is skewed or not mercator with those nice right angles between parallels and meridians, foorget about it.
  # The algorithm is simplified for our needs and uses the most extreme REF points in anticipation, that the chart is unskewed and rectangular, to achieve higher local precission, REF points as close as possible to the target coordinates should be used.
  def lon_at_x(x)
    if (!crosses_dateline)
      xres = (max_lon - min_lon) / (max_x - min_x)
      lon = min_lon + xres * (x - min_x)
    else # chart crosses the date line
      xres = (360 - max_lon + min_lon) / (max_x - min_x)
      lon = max_lon + xres * (x - min_x)
    end
    if (lon < -180)
      lon += 360
    else
      if (lon > 180)
        lon -= 360
      end
    end
    return lon 
  end
  
  # Recalculates the X and Y coordinates so that they reflex the new size
  # Recomputes the needed parameters
  def resize_to_percent(percent)
    @bsb_ra[0] = (@bsb_ra[0] * percent / 100).round
    @bsb_ra[1] = (@bsb_ra[1] * percent / 100).round
    @ref.each{|ref| ref.resize_to_percent(percent)}
    compute_dxdy
  end

  # Returns formatted header text
  def to_s
    str = String.new
    if (!@comment.empty?)
      str << @comment
      if (!@comment.end_with?("\n")) 
        str << "\n"
      end
    end
    if (@crr != nil && !@crr.empty?)
      str << "CRR/#{@crr}"
      if (!@crr.end_with?("\n")) 
        str << "\n"
      end
    end
    if (@ver != nil && !@ver.empty?) then str << "VER/#{@ver}" << "\n" end
    if (@bsb_na != nil && !@bsb_na.empty?)
      str << "BSB/NA=#{@bsb_na}" << "\n"
      str << "    NU=#{@bsb_nu}"
      str << ",RA=#{@bsb_ra[0]},#{@bsb_ra[1]}"
      str << ",DU=#{@bsb_du}"
      str << "\n"
    end
    if (@knp_sc != nil && !@knp_sc.empty?)
      str << "KNP/SC=#{@knp_sc}"
      str << ",GD=#{@knp_gd}"
      str << ",PR=#{@knp_pr}"
      str << "\n"
      str << "    PP=#{sprintf('%.1f', @knp_pp)}"
      str << ",PI=#{@knp_pi}"
      if(@knp_sp.class == "Array")
        if (@knp_sp.length == 2)
          str << ",SP=#{@knp_sp[0]},#{@knp_sp[1]}"
        else
          str << ",SP=#{@knp_sp[0]}"
        end
      else
        str << ",SP=#{@knp_sp}"
      end
      str << ",SK=#{@knp_sk}"
      str << ",TA=#{@knp_ta}"
      str << "\n"
      str << "    UN=#{@knp_un}"
      str << ",SD=#{@knp_sd}"
      str << ",DX=#{sprintf("%.1f", @knp_dx)}"
      str << ",DY=#{sprintf("%.1f", @knp_dy)}"
      str << "\n"
    end
    if (@knq_ec != nil && !@knq_ec.empty?)
      str << "KNQ/EC=#{@knq_ec}"
      str << ",GD=#{@knq_gd}"
      str << ",VC=#{@knq_vc}"
      str << "\n"
      str << "    SC=#{@knq_sc}"
      str << ",PC=#{@knq_pc}"
      str << ",P1=#{@knq_p1}"
      str << "\n"
      str << "    P2=#{@knq_p2}"
      str << ",P3=#{@knq_p3}"
      str << ",P4=#{@knq_p4}"
      str << ",GC=#{@knq_gc}"
      str << ",RM=#{@knq_rm}"
      str << "\n"
    end
    if (@ced_se != nil && !@ced_se.empty?)
      str << "CED/SE=#{@ced_se}"
      str << ",RE=#{@ced_re}"
      str << ",ED=#{@ced_ed}"
      str << "\n"
    end
    if (@cph != nil && !@cph.empty?) then str << "CPH/#{@cph}\n" end
    if (@ost != nil) then str << "OST/#{@ost}\n" end
    if (@ifm != nil) then str << "IFM/#{@ifm}\n" end
    if (dtm != nil)
      str << "DTM/#{sprintf("%.1f", @dtm[0])},#{sprintf("%.1f", @dtm[1])}\n"
    end
    @ref.each {|ref|
      str << ref.to_s << "\n"
    }
    if (@ply.length == 0)
      @ref.each{|point|
        str << point.to_PLY.to_s << "\n"
        }
      else
      @ply.each {|ply|
        str << ply.to_s << "\n"
      }
    end
    @rgb.each {|rgb|
      str << rgb.to_s << "\n"
    }
    @day.each {|day|
      str << day.to_s << "\n"
    }
    @dsk.each {|dsk|
      str << dsk.to_s << "\n"
    }
    @ngt.each {|ngt|
      str << ngt.to_s << "\n"
    }
    @ngr.each {|ngr|
      str << ngr.to_s << "\n"
    }
    @gry.each {|gry|
      str << gry.to_s << "\n"
    }
    @prc.each {|prc|
      str << prc.to_s << "\n"
    }
    @prg.each {|prg|
      str << prg.to_s << "\n"
    }
    str
  end
end



# This class represents a REF point
class REF
  # Point index
  attr_accessor :idx
  # Point x axis pixel coordinate
  attr_accessor :x
  # Point y axis pixel coordinate
  attr_accessor :y
  # Latitude of the point
  attr_accessor :latitude
  # Longitude of the point
  attr_accessor :longitude
  
  # Creating the object from the textual representation of the point in the chart header
  def read(ref_line)
    fields = ref_line.rstrip.split('/')[1].split(',')
    @idx = fields[0].to_i
    @x = fields[1].to_i
    @y = fields[2].to_i
    @latitude = fields[3].to_f
    @longitude = fields[4].to_f
  end

  # Returns formatted text for the header
  def to_s
    "REF/#{@idx},#{@x},#{@y},#{sprintf('%.8f', @latitude)},#{sprintf('%.8f', @longitude)}"
  end
  
  # Recalculates the X and Y coordinates so that they reflex the new size
  def resize_to_percent(percent)
    @x = (@x.to_f * percent / 100).round
    @y = (@y.to_f * percent / 100).round
  end
  
  # Returns the point converted to PLY point
  def to_PLY
    ply = PLY.new
    ply.read("PLY/#{@idx},#{@latitude},#{@longitude}")
    return ply
  end
end



# This class represents a point being part of the polygon defining the visible area of the chart
class PLY
  # Point index
  attr_accessor :idx
  # Latitude of the point
  attr_accessor :latitude
  # Longitude of the point
  attr_accessor :longitude
  
  # Creating the object from the textual representation of the point in the chart header
  def read(ply_line)
    fields = ply_line.rstrip.split('/')[1].split(',')
    @idx = fields[0].to_i
    @latitude = fields[1].to_f
    @longitude = fields[2].to_f
  end

  # Returns formatted text for the header
  def to_s
    "PLY/#{@idx},#{sprintf('%.8f', @latitude)},#{sprintf('%.8f', @longitude)}"
  end
end

# This class represents a color from the KAP's color table
class Color
  # Color table
  # Can be: RGB, DAY, DSK, NGT, NGR, GRY, PRC, PRG 
  attr_accessor :ct
  # Color index
  attr_accessor :idx
  # Red color value (0-255)
  attr_accessor :red
  # Green color value (0-255)
  attr_accessor :green
  # Blue color value (0-255)
  attr_accessor :blue
  
  # Creates the object from the header text line
  def read(rgb_line)
    fields = rgb_line.rstrip.split('/')
    @ct = fields[0]
    fields = fields[1].split(',')
    @idx = fields[0]
    @ced_red = fields[1]
    @green = fields[2]
    @blue = fields[2]
  end

  # Returns formatted text for the header
  def to_s
    "#{@ct}/#{@idx},#{@ced_red},#{@green},#{@blue}"
  end
end