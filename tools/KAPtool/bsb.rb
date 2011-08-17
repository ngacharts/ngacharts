# The classes for handling the BSB files, holding information
# about groups of KAP charts originating from the same paper source
#
# Author::    Pavel Kalian  (mailto:pavel@kalian.cz)
# Copyright:: Copyright (c) 2011 Pavel Kalian
# License::   Distributes under the terms of GPLv2 or later

# This class holds the BSB header information
# * The chapter numbers refer to IHO standard document S-61: http://88.208.211.37/iho_pubs/standard/S61E.pdf
# * The state copies the information for BSB Version 3.0, as described documents available from http://88.208.211.37/iho_pubs/standard/S-64_Edition_1-1/RNC_Test_Data_Sets/BSB_TDS/BSB_TDS.htm
# * The header can also contain following type of records:
# <tt>
#   N000005580001/RT=N,KN=12221_1,CA=CAUTION,DE=NOTICE TO MARINERS,P1=1028,8940
#       P2=1028,9112,P3=1974,9112,P4=1974,8940
# </tt>
class BSB
  # File comment, lines starting with ! 
  attr_accessor :comment
  # Format version
  attr_accessor :ver
  
  # CHT - General parameters
  
  # Chart name (3.4.2.2 RNC Name) - can't contain commas
  attr_accessor :cht_na
  # Chart number (3.4.2.2 RNC number)
  attr_accessor :cht_nu
  # Chart format
  # Possible values (may be more comma separated): 
  # - COASTAL
  # - HARBOR
  # - GENERAL
  # - SAILING
  # - INTERNATIONAL
  # - SMALL CRAFT ROUTE
  # - IWW ROUTE 
  # - (more?)
  attr_accessor :chf
  
  # CED   Edition Parameters
  
  # Source Edition  (3.4.2.5 Chart edition date and/or number) - can't contain commas
  attr_accessor :ced_se
  # Raster Edition
  attr_accessor :ced_re
  # Edition Date  (3.4.2.5 Chart edition date and/or number) - can't contain commas
  attr_accessor :ced_ed    

  # NTM   NTM Record
  
  # NTM Edition Number
  attr_accessor :ntm_ne
  # NTM Date  (3.4.2.6 Last update or NTM applied)
  attr_accessor :ntm_nd
  # Base Flag
  attr_accessor :ntm_bf
  # Base Date
  attr_accessor :ntm_bd
  
  # Number of KAPPs
  # Sometimes can contain two comma separated numbers, in this case the first one is number of KAP files and the second one is for example 558 from records starting with N000005580001/
  # The meaning of this yet to be determined
  attr_accessor :chk
  # Chart Originator  (3.4.2.1 Producing agency identifier code)
  attr_accessor :org
  # Manufacturer
  attr_accessor :mfr
  
  # Array of KAP files composing this chart
  attr_accessor :kap
  
  # Observed in BSB files collected, but missing in the available documentation

  # ?Chart geodetic datum? (observed value is number or more comma separated numbers, most often 0, but values like 11,13,14,17 also observed) In some files 'Unknown' is used
  attr_accessor :cgd
  # Certificate of authenticity - multi-line text
  attr_accessor :crr
  # ?Region? Not seen very often (observed values are comma separated numbers like 4,6,36)
  attr_accessor :rgn
  
  # default initializer
  def initialize
    @kap = Array.new
  end
  
  # Parses the string and finds the value for the key
  def parse_key_value(header, key)
    if(header.include?(key))
      begidx = header.index(key) + key.length 
      endidx = header.index(/[,\n\r]/, begidx)
      return header[begidx, endidx-begidx].strip
    else
      return nil
    end
  end
  
  # Parses the text of the BSB file
  def read(text)
    @comment = String.new
    @org = String.new
    @crr = String.new
    @kap = Array.new
    previous_was_kap = false
    previous_was_org = false
    previous_was_crr = false
    text.each_line { |line|
      if (line.strip[0] == '!') 
        @comment << line
      end
      if (line.index(/K[0..9]/) != nil || (previous_was_kap && line.start_with?("    ")))
        if (line.index(/K[0..9]/) != nil)
          @kap << KAPinfo.new(line)
        else
          @kap[@kap.length - 1].read(line)
        end
        previous_was_kap = true
      else
        previous_was_kap = false
      end
      if (line.index("ORG/") != nil || (previous_was_org && line.start_with?("    ")))
        @org << line
        previous_was_org = true
      else
        previous_was_org = false
      end
      if (line.index("CRR/") != nil || (previous_was_crr && line.start_with?("    ")))
        @crr << line
        previous_was_crr = true
      else
        previous_was_crr = false
      end
      }
    @org = @org.sub("ORG/", "")
    @crr = @crr.sub("CRR/", "")  
    @cht_na = parse_key_value(text, "CHT/NA=")
    @cht_nu = parse_key_value(text, "NU=")
    @chf = parse_key_value(text, "CHF/")
    @ced_se = parse_key_value(text, "CED/SE=")
    @ced_re = parse_key_value(text, "RE=")
    @ced_ed = parse_key_value(text, "ED=")
    @ntm_ne = parse_key_value(text, "NTM/NE=")
    @ntm_nd = parse_key_value(text, "ND=")
    @ntm_bf = parse_key_value(text, "BF=")
    @ntm_bd = parse_key_value(text, "BD=")
    @ver = parse_key_value(text, "VER/")
    #@chk = parse_key_value(text, "CHK/")
    if(text.include?("CHK/"))
      begidx = text.index("CHK/") + "CHK/".length
      endidx = text.index(/[\n\r]/, begidx)
      @chk = text[begidx, endidx-begidx].strip
    else
      @chk = nil
    end
    @cgd = parse_key_value(text, "CGD/")
    @mfr = parse_key_value(text, "MFR/")
    if(text.include?("RGN/"))
      begidx = text.index("RGN/") + "RGN/".length
      endidx = text.index(/[\n\r]/, begidx)
      @rgn = text[begidx, endidx-begidx].strip
    else
      @rgn = nil
    end
  end
  
  # Outputs the formatted text of the file
  def to_s
    str = String.new
    str << @comment
    if (!@comment.end_with?("\n")) 
      str << "\n"
    end
    str << "CRR/#{@crr}"
    if (!@crr.end_with?("\n")) 
      str << "\n"
    end
    str << "VER/#{@ver}" << "\n"
    str << "CHT/NA=#{@cht_na}" << "\n"
    str << "    NU=#{@cht_nu}\n"
    str << "CHF/#{@chf}\n"
    str << "CED/SE=#{@ced_se}"
    str << ",RE=#{@ced_re}"
    str << ",ED=#{@ced_ed}"
    str << "\n"
    str << "NTM/NE=#{@ntm_ne}"
    str << ",ND=#{@ntm_nd}"
    str << ",BF=#{@ntm_bf}"
    str << ",BD=#{@ntm_bd}"
    str << "\n"
    str << "CHK/#{@chk}" << "\n"
    str << "ORG/#{@org}"
    if (!@org.end_with?("\n")) 
      str << "\n"
    end
    str << "MFR/#{@mfr}" << "\n"
    str << "CGD/#{@cgd}" << "\n"
    str << "RGN/#{@rgn}" << "\n"
    @kap.each {|kap|
      str << kap.to_s << "\n"
      }
    str
  end
end

# This class holds the information about individual chart composing the set
# Knn   Knn Record
class KAPinfo
  # Chart index (1..X)
  attr_accessor :idx
  # Kapp Name (no commas)
  attr_accessor :na
  # Kapp Number (3.4.2.3 Chart identifier (number) if different than RNC)
  attr_accessor :nu
  # Kapp Type
  # Possible values: BASE, INSET, more?
  attr_accessor :ty
  # Kapp File Name
  attr_accessor :fn
  
  # Parses the text for the value corresponding with a given key
  def parse_key_value(header, key, default)
    if (header == nil)
      return default
    end
    if(header.include?(key))
      begidx = header.index(key) + key.length
      endidx = header.index(/[,\n\r]/, begidx)
      if(endidx == nil)
        endidx = header.length
      end
      return header[begidx, endidx - begidx].strip
    else
      return default
    end
  end
    
  # Loads the class from the BSB file record
  def load(kap_line)
    fields = kap_line.rstrip.split("/")
    @idx = fields[0].sub("K", "")
    read(fields[1])
  end
  
  # Reads the chart parameters
  def read(text)
    @na = parse_key_value(text, "NA=", @cht)
    @nu = parse_key_value(text, "NU=", @cht)
    @ty = parse_key_value(text, "TY=", @ty)
    @fn = parse_key_value(text, "FN=", @fn)
  end
  
  # Formats the chart info for the file
  def to_s
    "K#{@idx}/NA=#{@na}\n    NU=#{@nu},TY=#{@ty},FN=#{@fn}"
  end
end