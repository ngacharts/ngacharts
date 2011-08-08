class BSB
  attr_accessor :comment, :na, :nu, :chf, :se, :re, :ed, :ver, :chk, :cgd, :org, :mfr
  attr_accessor :kap
  
  def parse_key_value(header, key)
    if(header.include?(key))
      begidx = header.index(key) + key.length 
      endidx = header.index(/[,\n\r]/, begidx)
      return header[begidx, endidx-begidx].strip
    else
      return nil
    end
  end
  
  def readheader(header_text)
    @comment = String.new
    @org = String.new
    @kap = Array.new
    previous_was_kap = false
    previous_was_org = false
    header_text.each_line { |line|
      if (line.strip[0] == '!') 
        @comment << line
      end
      if (line.index(/K[0..9]/) != nil || (previous_was_kap && line.start_with?("    ")))
        if (line.index(/K[0..9]/) != nil)
          @kap << KAPinfo.new(line)
        else
          @kap[@kap.length - 1].readheader(line)
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
      }
    @org = @org.sub("ORG/", "")    
    @na = parse_key_value(header_text, "CHT/NA=")
    @nu = parse_key_value(header_text, "NU=")
    @chf = parse_key_value(header_text, "CHF/")
    @se = parse_key_value(header_text, "CED/SE=")
    @re = parse_key_value(header_text, "RE=")
    @ed = parse_key_value(header_text, "ED=")
    @ver = parse_key_value(header_text, "VER/")
    @chk = parse_key_value(header_text, "CHK/") #redo - info about all the charts
    @cgd = parse_key_value(header_text, "CGD/")
    @mfr = parse_key_value(header_text, "MFR/")
  end
  
  def to_s
    str = String.new
    str << @comment
    if (!@comment.end_with?("\n")) 
      str << "\n"
    end
    str << "CHT/NA=#{@na}" << "\n"
    str << "    NU=#{@nu}\n"
    str << "CHF/#{@chf}\n"
    str << "CED/SE=#{@se}"
    str << ",RE=#{@re}"
    str << ",ED=#{@ed}"
    str << "\n"
    str << "VER/#{@ver}" << "\n"
    str << "CHK/#{@chk}" << "\n"
    str << "CGD/#{@cgd}" << "\n"
    str << "ORG/#{@org}"
    if (!@org.end_with?("\n")) 
      str << "\n"
    end
    str << "MFR/#{@mfr}" << "\n"
    @kap.each {|kap|
      str << kap.to_s << "\n"
      }
    str
  end
end

class KAPinfo
  attr_accessor :idx, :na, :nu, :ty, :fn
  
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
  
  def initialize(kap_line)
    fields = kap_line.rstrip.split("/")
    @idx = fields[0].sub("K", "")
    readheader(fields[1])
  end
  
  def readheader(header_text)
    @na = parse_key_value(header_text, "NA=", @na)
    @nu = parse_key_value(header_text, "NU=", @nu)
    @ty = parse_key_value(header_text, "TY=", @ty)
    @fn = parse_key_value(header_text, "FN=", @fn)
  end
  
  def to_s
    "K#{@idx}/NA=#{@na},NU=#{@nu}\n    TY=#{@ty},FN=#{@fn}"
  end
end

bsb = BSB.new
bsb.readheader("!Copyright 1996, NDI. All Rights Reserved
CHT/NA=VANCOUVER ISLAND JUAN DE FUCA STRAIT TO ,NU=3001
CHF/GENERAL
CED/SE=3001, RE= 300101, ED=01/30/96
VER/1.1
CHK/1,300101
CGD/UNKNOWN
ORG/Nautical Data International Inc., 1 Military Rd., P.O. Box 127, Station C S
    t. John's, NF, A1C 5H5, on behalf of: Canadian Hydrographic Service, 615 Bo
    oth St., Room 237, Ottawa, Ontario, K1A 0E6

K01/NA=VANCOUVER ISLAND JUAN DE FUCA STRAIT TO ,NU=3001,TY=BASE,FN=300101.kap")
    
puts bsb
