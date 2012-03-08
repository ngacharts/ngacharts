#!/usr/bin/ruby1.9.1
# Dezoomify. See README.markdown.
# By Henrik Nyh <http://henrik.nyh.se> 2009-02-06 under the MIT License.

#Modified by "cagney" 2011-07-03
#Modified by nohal 2011-08-03
#taking chart #Number as argument
#hardcoding the noaa site
#renaming and moving the final chart picture to pwd
#deleting all jpg tiles in /tmp
#limit memory 2048
#using ruby 1.9

require 'net/http'
require 'tempfile'
require 'open-uri'
require 'rubygems'
require 'nokogiri'
require 'fileutils'

def reconstruct_tile(zoom_level, tx, ty, target_file)
  puts "reconstructing tile #{zoom_level}-#{tx}-#{ty}"
  my_zoom_level = zoom_level - 1
  my_x = (tx / 2).floor
  #puts "my_x: #{my_x}"
  my_y = (ty / 2).floor
  #puts "my_y: #{my_y}"
  my_tile_width = $tilesize
  my_tile_height = $tilesize
  my_size_coef = 1;
  ($zoom - my_zoom_level).times do
    my_size_coef = my_size_coef * 2
  end
  my_tw = ($width / ($tilesize * my_size_coef)).ceil
  my_th = ($height / ($tilesize * my_size_coef)).ceil
  #puts "my_tw: #{my_tw}"
  #puts "my_th: #{my_th}"
  my_orig_tw = ($width / ($tilesize * my_size_coef / 2)).ceil
  my_orig_th = ($height / ($tilesize * my_size_coef / 2)).ceil
  #puts "my_size_coef: #{my_size_coef}"
  #puts "my_orig_tw: #{my_orig_tw}"
  #puts "my_orig_th: #{my_orig_th}"
  if (tx == my_orig_tw - 1)
    my_tile_width = ($width / my_size_coef * 2).floor - (my_orig_tw - 1) * $tilesize
  end
  if (ty == my_orig_th - 1)
    my_tile_height = ($height / my_size_coef * 2).floor - (my_orig_th - 1) * $tilesize
  end
  if (my_tile_height > $tilesize)
    my_tile_height-= $tilesize
  end
  if (my_tile_width > $tilesize)
    my_tile_width-= $tilesize
  end
  #puts "reconstructed tile size will be: #{my_tile_width} x #{my_tile_height}"
  tile_count_before_my_level = $tile_counts[0..-2 - $zoom + my_zoom_level].inject(0) {|sum, num| sum + num }
  my_tile_group = ((my_x + my_y * my_tw + tile_count_before_my_level) / $tilesize).floor
  my_filename = '%s-%s-%s.jpg' % [my_zoom_level, my_x, my_y]
  my_tile_url = URI.join($full_path.to_s, "TileGroup#{my_tile_group}/#{my_filename}")
  my_url = URI.join(my_tile_url.to_s, my_filename)
  my_target_file = '%s.%s' % [target_file, my_filename]
  if (my_x * 2 == tx)
    if (my_y * 2 == ty)
      gravity = "NorthWest"
    else
      gravity = "SouthWest"
    end
  else
    if (my_y *2 == ty)
      gravity = "NorthEast"
    else
      gravity = "SouthEast"
    end
  end
  #puts "gravity: #{gravity}"
  
  puts "    Getting #{my_url}..."
  File.open(my_target_file, 'wb') {|f|
  begin
    f.print my_url.read
  rescue OpenURI::HTTPError
    puts "Tile #{my_zoom_level}-#{my_x}-#{my_y} not found, trying to reconstruct from lower zoom levels"
    reconstruct_tile my_zoom_level, my_x, my_y, my_target_file
  end
  }
  #and now let's recreate the tile...
  #"C:\\Program Files\\GraphicsMagick-1.3.12-Q16\\gm.exe" 
  `convert #{my_target_file} -resize 200% -gravity #{gravity} -crop #{my_tile_width}x#{my_tile_height}+0+0 #{target_file}`
  #puts "my: #{my_target_file} gravity: #{gravity} target: #{target_file}"
  File.delete(my_target_file)
end

unless ARGV[0]
	puts "\nUseage: #{$0}  Chart#"
	puts "Chart# is the chart to download from \nhttp://www.charts.noaa.gov/NGAViewer/, identified by its number"
	puts "The chart picture will be downloaded to your present working direktory."
	puts ""
	exit(false)
 end
 

 page_url = "http://www.charts.noaa.gov/NGAViewer/#{ARGV[0]}.shtml" 
 working_dir = Dir.getwd
 
#chart.each_with_index do |page_url, page_url_index|
  puts " Visiting #{page_url}"
  
  html = open(page_url).read
  paths = html.scan(/zoomifyImagePath=([^"'&]+)/).flatten.map {|path| path.gsub(' ', '%20') }.uniq
  
  paths.each_with_index do |path, path_index|
    $full_path = URI.join(page_url, path+'/')
    puts " Found image path #{$full_path}"


    # <IMAGE_PROPERTIES WIDTH="1737" HEIGHT="2404" NUMTILES="99" NUMIMAGES="1" VERSION="1.8" TILESIZE="256"/>
    xml_url = URI.join($full_path.to_s, 'ImageProperties.xml')
    doc = Nokogiri::XML(open(xml_url))
    props = doc.at('IMAGE_PROPERTIES')

    $width = props[:WIDTH].to_i
    $height = props[:HEIGHT].to_i
    $tilesize = props[:TILESIZE].to_f

    tiles_wide = ($width/$tilesize).ceil
    tiles_high = ($height/$tilesize).ceil 
    
    # Determine max zoom level.
    # Also determine tile_counts per zoom level, used to determine tile group.
    # With thanks to http://trac.openlayers.org/attachment/ticket/1285/zoomify.patch.
    $zoom = 0
    w = $width
    h = $height
    $tile_counts = []
    while w > $tilesize || h > $tilesize
      $zoom += 1
      
      t_wide = (w / $tilesize).ceil
      t_high = (h / $tilesize).ceil
      $tile_counts.unshift t_wide*t_high
      
      w = (w / 2.0).floor
      h = (h / 2.0).floor
    end
    $tile_counts.unshift 1  # Zoom level 0 has a single tile.
    tile_count_before_level = $tile_counts[0..-2].inject(0) {|sum, num| sum + num }
    
    files_by_row = []
    tiles_high.times do |y|
    #y=61
      row = []
      tiles_wide.times do |x|
    #x=46
        filename = '%s-%s-%s.jpg' % [$zoom, x, y]
        local_filepath = "/tmp/zoomify-#{filename}"
        row << local_filepath
        
        tile_group = ((x + y * tiles_wide + tile_count_before_level) / $tilesize).floor

        tile_url = URI.join($full_path.to_s, "TileGroup#{tile_group}/#{filename}")
        url = URI.join(tile_url.to_s, filename)
        puts "    Getting #{url}..."
        File.open(local_filepath, 'wb') {|f|
          begin
            f.print url.read
          rescue OpenURI::HTTPError
            puts "Tile #{$zoom}-#{x}-#{y} not found, trying to reconstruct from lower zoom levels"
            reconstruct_tile $zoom, x, y, local_filepath
          end
        }
      end
      files_by_row << row
    end
    

    # `montage` is ImageMagick.
    # We first stitch together the tiles of each row, then stitch all rows.
    # Stitching the full image all at once can get extremely inefficient for large images.
    
    puts "    Stitching #{tiles_wide} x #{tiles_high} = #{tiles_wide*tiles_high} tiles..."
    
    row_files = []
    files_by_row.each_with_index do |row, index|
      filename = "/tmp/zoomify-row-#{index}.jpg"
      `montage #{row.join(' ')} -geometry +0+0 -tile #{tiles_wide}x1 #{filename}`
      row_files << filename
    end
    
    filename = "/tmp/zoomified-#{ARGV[0]}.jpg"
    `montage -limit memory 2048 #{row_files.join(' ')} -geometry +0+0 -tile 1x#{tiles_high} #{filename}`

#    File.rename(filename,"#{chart}.jpg")

    FileUtils.mv("#{filename}","#{working_dir}/#{ARGV[0]}.jpg")
    puts "Finished:#{ARGV[0]}.jpg"
     FileUtils.cd('/tmp', options = {})
     #FileUtils.rm Dir.glob('*.jpg')   

   end
  
#end
