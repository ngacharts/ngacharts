class KAPHeader
  attr_accessor :comment, :ver
  attr_accessor :na, :nu, :ra, :du
  attr_accessor :sc, :gd, :pr, :pp, :pi, :sp, :sk, :un, :sd, :dx, :dy
  attr_accessor :se, :re, :ed, :ver, :ost, :ifm
  attr_accessor :ref, :ply
  attr_accessor :dtm, :rgb, :cph, :ta
  
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
    @ref = Array.new
    @ply = Array.new
    @rgb = Array.new
    header_text.each_line { |line|
      if (line.strip[0] == '!') 
        @comment << line
      end
      if (line.index("REF") != nil)
        @ref << REF.new(line)
      end
      if (line.index("PLY") != nil)
        @ply << PLY.new(line)
      end
      if (line.index("RGB") != nil)
        @ply << RGB.new(line)
      end
      }
        
    @na = parse_key_value(header_text, "BSB/NA=")
    @nu = parse_key_value(header_text, "NU=")

    begidx = header_text.index("RA=") + "RA=".length 
    endidx = header_text.index(",", begidx)
    endidx = header_text.index(",", endidx + 1)
    @ra = header_text[begidx, endidx-begidx].split(',')

    @du = parse_key_value(header_text, "DU=")
    @sc = parse_key_value(header_text, "KNP/SC=")
    @gd = parse_key_value(header_text, "GD=")
    @pr = parse_key_value(header_text, "PR=")
    @pp = parse_key_value(header_text, "PP=")
    @pi = parse_key_value(header_text, "PI=")
    
    #Hard to say if it has 1 or 2 components... we don't even know what it is...
    begidx = header_text.index("SP=") + "SP=".length 
    endidx = header_text.index(",", begidx)
    endidx = header_text.index(",", endidx + 1)
    if (endidx < header_text.index("=", begidx))
      @sp = header_text[begidx, endidx-begidx].split(',')
    else
      @sp = Array.new
      @sp[0] = parse_key_value(header_text, "SP=")
    end

    @ta = parse_key_value(header_text, "TA=")
    @sk = parse_key_value(header_text, "SK=")
    @un = parse_key_value(header_text, "UN=")
    @sd = parse_key_value(header_text, "SD=")
    @dx = parse_key_value(header_text, "DX=")
    @dy = parse_key_value(header_text, "DY=")
    @se = parse_key_value(header_text, "SE=")
    @re = parse_key_value(header_text, "RE=")
    @ed = parse_key_value(header_text, "ED=")
    @ver = parse_key_value(header_text, "VER/")
    @ost = parse_key_value(header_text, "OST/")
    @ifm = parse_key_value(header_text, "IFM/")
    @cph = parse_key_value(header_text, "CPH/")
    
    if(header_text.include?("DTM/"))
      begidx = header_text.index("DTM/") + "DTM/".length 
      endidx = header_text.index(",", begidx)
      endidx = header_text.index(/[,\n]/, endidx + 1)
      @dtm = header_text[begidx, endidx-begidx].split(',')
    end
  end
  
  def to_s
    str = String.new
    str << @comment << "\n"
    str << "VER/#{@ver}" << "\n"
    str << "BSB/NA=#{@na}" << "\n"
    str << "    NU=#{@nu}"
    str << ",RA=#{@ra[0]},#{@ra[1]}"
    str << ",DU=#{@du}"
    str << "\n"
    str << "KNP/SC=#{@sc}"
    str << ",GD=#{@gd}"
    str << ",PR=#{@pr}"
    str << "\n"
    str << "    PP=#{@pp}"
    str << ",PI=#{@pi}"
    if(@sp.length == 2)
      str << ",SP=#{@sp[0]},#{@sp[1]}"
    else
      str << ",SP=#{@sp[0]}"
    end
    str << ",SK=#{@sk}"
    str << ",TA=#{@ta}"
    str << "\n"
    str << "    UN=#{@un}"
    str << ",SD=#{@sd}"
    str << ",DX=#{@dx}"
    str << ",DY=#{@dy}"
    str << "\n"
    str << "CED/SE=#{@se}"
    str << ",RE=#{@re}"
    str << ",ED=#{@ed}"
    str << "\n"
    str << "CPH/#{@cph}\n"
    str << "OST/#{@ost}\n"
    str << "IFM/#{@ifm}\n"
    if (dtm != nil)
      str << "DTM/#{@dtm[0]},#{@dtm[1]}\n"
    end
    @ref.each {|ref|
      str << ref.to_s << "\n"
      }
    @ply.each {|ply|
      str << ply.to_s << "\n"
      }
    @rgb.each {|rgb|
      str << rgb.to_s << "\n"
      }
    str
  end
end

class REF
  attr_accessor :idx, :x, :y, :latitude, :longitude
  
  def initialize(ref_line)
    fields = ref_line.rstrip.split('/')[1].split(',')  
    @idx = fields[0]
    @x = fields[1]
    @y = fields[2]
    @latitude = fields[3]
    @longitude = fields[4]
  end
  
  def to_s
    "REF/#{@idx},#{@x},#{@y},#{@latitude},#{@longitude}"
  end
end

class PLY
  attr_accessor :idx, :latitude, :longitude
  
  def initialize(ply_line)
    fields = ply_line.rstrip.split('/')[1].split(',')  
    @idx = fields[0]
    @latitude = fields[1]
    @longitude = fields[2]
  end
  
  def to_s
    "PLY/#{@idx},#{@latitude},#{@longitude}"
  end
end

class RGB
  attr_accessor :idx, :red, :green, :blue
  
  def initialize(rgb_line)
    fields = rgb_line.rstrip.split('/')[1].split(',')  
    @idx = fields[0]
    @red = fields[1]
    @green = fields[2]
    @blue = fields[2]
  end
  
  def to_s
    "RGB/#{@idx},#{@red},#{@green},#{@blue}"
  end
end

kap = KAPHeader.new
kap.readheader("! An example BSB text header
    VER/3.0
    BSB/NA=Australia 3000000
        NU=,RA=625,480,DU=50
    KNP/SC=3000000,GD=,PR=LAMBERT CONFORMAL CONIC,PP=145.0
        PI=0.0,SP=Unknown,0,SK=0.0
        UN=METRES,SD=,DX=6000.0,DY=6000.0
    OST/1
    IFM/3
    RGB/1,199,231,252
    RGB/2,174,234,84
    RGB/3,255,254,206
    RGB/4,226,65,6
    DTM/0.0,0.0
")

puts kap
